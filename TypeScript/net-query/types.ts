import {
  QueryKey,
  RefetchOptions,
  UseQueryOptions as RQUseQueryOptions,
} from '@tanstack/react-query';
import { FetchOptions, INetworking, YTResponse } from '@yunti-private/net';

export type UseQueryOptions<DTO> = {
  /** `react-query`的请求选项 */
  queryOptions?: Omit<
    RQUseQueryOptions<YTResponse<DTO>>,
    'queryKey' | 'queryFn'
  >;
  /** `INetworking`的请求选项 */
  fetchOptions?: FetchOptions<DTO>;
} & (
  | {
      /** 不使用缓存，每次都会发起全新的请求，即使参数完全一致（默认`false`） */
      noCache?: true;
      /** 在参数相同的情况下，数据不会过期，多用于数据不常更新的场景（如省市区的级联数据、对接平台列表等，默认`false`） */
      noExpiration?: false | undefined;
    }
  | {
      noExpiration?: true;
      noCache?: false | undefined;
    }
);

export type INetworkingContext = {
  net: INetworking;
};

export type UseQueryDataType<DTO> = {
  /** 请求的返回值 */
  data: DTO | undefined;
  /** 是否请求成功 */
  success: boolean;
  /** 失败错误码 */
  errorCode: number | undefined;
  /** 错误信息 */
  errorMsg: string | undefined;
};

export type UseQueryReturnType<DTO> = UseQueryDataType<DTO> & {
  /** 请求是否正在进行中 */
  isLoading: boolean;
  /** 当前请求的key，可结合`queryClient`用于刷新等操作 */
  queryKey: QueryKey;
  /** 基于当前传入`useQuery`的参数，手动触发重新请求，更新data的同时也能直接拿到返回值 */
  reloadData: (options?: RefetchOptions) => Promise<YTResponse<DTO>>;
};

export type DefaultParamsType = Record<string, unknown>;
