import { createCtx } from '../utils/createCtx';
import { INetworkingContext } from './types';

/** 未请求到数据的默认返回（不包含msg） */
export const commonFailureResWithoutMsg = Object.freeze({
  data: undefined,
  success: false,
});

const [useINetworkingContext, INetworkingContextProvider] =
  createCtx<INetworkingContext>();

export { INetworkingContextProvider, useINetworkingContext };
