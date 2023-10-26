/**
 * @name 解析JSON字符串
 * @param str JSON字符串
 * @param type 解析后的数据类型，用于初始化返回 对象或者数组
 *
 * 注意：
 * 1. type请在非常确定数据类型的情况下使用，
 * 2. 会出现显式的传入了范型，但解析的结果是另一种类型的情况，请做好兼容处理
 * @returns T | null 解析后的数据
 */
export function parseJSON<T = unknown>(
  str: string | undefined | null
): T | null;
export function parseJSON<T = unknown>(
  str: string | undefined | null,
  type: "object" | "array"
): T;
export function parseJSON<T = unknown>(
  str: string | undefined | null,
  type?: "object" | "array"
): T | null {
  const getEmpty = () => {
    if (type === "array") {
      return [] as unknown as T;
    } else if (type === "object") {
      return {} as unknown as T;
    } else {
      return null;
    }
  };

  if (str === undefined || str === null) {
    return getEmpty();
  }

  try {
    return JSON.parse(str) as T;
  } catch {
    return getEmpty();
  }
}
