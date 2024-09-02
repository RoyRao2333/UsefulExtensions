import {
  QueryFunctionContext,
  RefetchOptions,
  useQuery,
} from '@tanstack/react-query';
import { YTRequest, YTResponse } from '@yunti-private/net';
import { useCallback, useMemo } from 'react';
import { dealWithUnknownError } from '../utils/dealWithUnknownError';
import { commonFailureResWithoutMsg, useINetworkingContext } from './constants';
import {
  DefaultParamsType,
  UseQueryDataType,
  UseQueryOptions,
  UseQueryReturnType,
} from './types';
import { makeQueryKey } from './utils';

/**
 * 通用数据请求hook
 *
 * @author anye
 * @see https://tanstack.com/query/latest/docs/framework/react/quick-start
 */
const useQueryHook = <DTO, ParamsType extends Array<DefaultParamsType>>(
  req: YTRequest<DTO> | ((...params: ParamsType) => YTRequest<DTO>) | null,
  options?: UseQueryOptions<DTO>,
): UseQueryReturnType<DTO> => {
  /**
   * 为避免无意义重渲染或循环调用，解构须知：
   * 1. 若解构的数据为Primitive类型（number, string, boolean, undefined, null等），可以提供默认值
   * 2. 如果非Primitive类型（object, array等），请勿提供默认值，而是在使用的时候处理默认情况，如`myObj ?? {}`
   */
  const {
    noCache = false,
    noExpiration = false,
    fetchOptions,
    queryOptions,
  } = options ?? {};

  const { net } = useINetworkingContext();

  const requestQueryKey = useMemo(() => {
    const requestObj =
      typeof req === 'function' ? req(...([] as unknown as ParamsType)) : req;
    return makeQueryKey(requestObj);
  }, [req]);

  /** 若不需要缓存，则将数据标为立即失效 */
  const noCacheOptions = useMemo((): Partial<
    UseQueryOptions<DTO>['queryOptions']
  > => {
    if (noCache) {
      return {
        staleTime: 0,
        gcTime: 0,
      };
    }
    return {};
  }, [noCache]);

  /** 若需要数据持久化，则将数据标为不会失效 */
  const noExpirationOptions = useMemo((): Partial<
    UseQueryOptions<DTO>['queryOptions']
  > => {
    if (noExpiration) {
      return {
        staleTime: Infinity,
        gcTime: Infinity,
      };
    }
    return {};
  }, [noExpiration]);

  const fetchData = useCallback(
    async (request: YTRequest<DTO> | null): Promise<YTResponse<DTO>> => {
      if (!request) {
        return commonFailureResWithoutMsg;
      }

      let res: YTResponse<DTO>;

      try {
        res = await net.fetch<DTO>(request, fetchOptions);
      } catch (err) {
        res = {
          ...commonFailureResWithoutMsg,
          msg: dealWithUnknownError(err),
        };
      }

      return res;
    },
    [fetchOptions, net],
  );

  const queryFn = useCallback(
    (context: QueryFunctionContext): Promise<YTResponse<DTO>> => {
      const { queryKey } = context;
      return fetchData(queryKey[1] as YTRequest<DTO>);
    },
    [fetchData],
  );

  const {
    data: ytResponse,
    isFetching,
    refetch,
  } = useQuery<YTResponse<DTO>>(
    /* 如无必要，请勿调整options参数顺序，或@anye进行讨论 */
    {
      queryKey: requestQueryKey,
      queryFn,
      enabled: !!req,
      ...queryOptions,
      ...noCacheOptions,
      ...noExpirationOptions,
    },
  );

  const reloadData = useCallback(
    async (options?: RefetchOptions): Promise<UseQueryDataType<DTO>> => {
      const { data } = await refetch(options);
      return {
        data: data?.data,
        success: data?.success || false,
        errorMsg: data?.msg,
        errorCode: data?.errorCode,
      };
    },
    [refetch],
  );

  return {
    data: ytResponse?.data,
    success: ytResponse?.success || false,
    errorMsg: ytResponse?.msg,
    errorCode: ytResponse?.errorCode,
    isLoading: isFetching,
    queryKey: requestQueryKey,
    reloadData,
  };
};

export { useQueryHook as useQuery };
