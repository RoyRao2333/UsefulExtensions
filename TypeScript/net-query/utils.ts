import {
  DefaultOptions,
  QueryClient,
  QueryClientConfig,
  QueryKey,
} from '@tanstack/react-query';
import { YTRequest } from '@yunti-private/net';

/** 生成一个全局使用的`QueryClient`实例 */
export const makeQueryClient = (options?: DefaultOptions): QueryClient => {
  const finalConfig: QueryClientConfig = {
    defaultOptions: {
      queries: {
        /** 页面聚焦时，不希望重新调用接口 */
        refetchOnWindowFocus: false,
        /** 请求完毕后，立即将数据标为过期，下次会重新请求 */
        staleTime: 0,
        /** 数据没有任何订阅的时候，会继续保存5分钟，在5分钟内再次访问会优先取得缓存，同时进行新的请求 */
        gcTime: 300000,
      },
      ...options,
    },
  };
  return new QueryClient(finalConfig);
};

/** 根据`YTRequest`，生成`q`ueryKey` */
export const makeQueryKey = <DTO>(req: YTRequest<DTO> | null): QueryKey => {
  return [req?.url, req];
};
