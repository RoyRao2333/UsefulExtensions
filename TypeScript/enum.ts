/**
 * 枚举转 Map 对象
 * @param enumData
 * @returns Map Object
 */
export const enumTransformMap = (enumData: Record<string, any>) => {
  /** 注意点: 枚举会把value为number类型 key,value互换，string类型则不会 */
  const enumKeys = Object.keys(enumData);
  return enumKeys.reduce((initMap: { [key: string | number]: string }, key) => {
    const values = enumData[key];
    const val = enumData[values];
    if (values) {
      /** 全是数字类型, val可能刚好数字为0 */
      if (val || val === 0) {
        if (typeof values === 'string' && typeof val === 'number') {
          initMap[val] = values;
        }
      } else {
        initMap[values] = key;
      }
    }
    return initMap;
  }, {});
};