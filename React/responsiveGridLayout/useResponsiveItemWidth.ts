import { useState, useEffect, RefObject } from 'react';
import { useResizeDetector } from 'react-resize-detector';

type UseResponsiveItemWidthProps = {
  /** 父容器的ref */
  containerRef: RefObject<HTMLElement>;
  /** 每个item最小的宽度 */
  minItemWidth: number;
  /** item之间的间距 */
  gap?: number;
};

type UseResponsiveItemWidthReturn = {
  /** 计算后的item宽度 */
  itemWidth: number;
};

/** 动态计算容器中每个item的宽度 */
export const useResponsiveItemWidth = (
  props: UseResponsiveItemWidthProps,
): UseResponsiveItemWidthReturn => {
  // props
  const { containerRef, minItemWidth, gap = 0 } = props;
  // states
  const [itemWidth, setItemWidth] = useState(minItemWidth);

  const onResize = (width?: number) => {
    if (containerRef.current) {
      const containerWidth = width || containerRef.current.offsetWidth;
      const itemsPerRow = Math.floor(
        (containerWidth + gap) / (minItemWidth + gap),
      );
      const newWidth = (containerWidth - itemsPerRow * gap) / itemsPerRow;
      setItemWidth(newWidth);
    }
  };

  // 使用react-resize-detector库来监听容器宽度的变化
  useResizeDetector({
    onResize,
    targetRef: containerRef,
  });

  return { itemWidth };
};
