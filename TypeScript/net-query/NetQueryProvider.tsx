import { DefaultOptions, QueryClientProvider } from '@tanstack/react-query';
import { INetworking } from '@yunti-private/net';
import { PropsWithChildren, useMemo, useRef } from 'react';
import { INetworkingContextProvider } from './constants';
import { INetworkingContext } from './types';
import { makeQueryClient } from './utils';

type Props = {
  net: INetworking;
  options?: DefaultOptions;
};

/**
 * @description net-query所需provider，尽量包裹在App入口外层
 * @author anye
 * @date 2024-08-28
 */
export const NetQueryProvider = (props: PropsWithChildren<Props>) => {
  const { children, net, options } = props;

  const queryClientRef = useRef(makeQueryClient(options));

  const contextValue = useMemo(
    (): INetworkingContext => ({
      net,
    }),
    [net],
  );

  return (
    <QueryClientProvider client={queryClientRef.current}>
      <INetworkingContextProvider value={contextValue}>
        {children}
      </INetworkingContextProvider>
    </QueryClientProvider>
  );
};
