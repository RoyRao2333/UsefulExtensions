import React, { CSSProperties, ReactNode, useMemo, useRef } from 'react';
import classNames from 'classnames';
import { useResponsiveItemWidth } from './useResponsiveItemWidth';

type Props = Omit<JSX.IntrinsicElements['div'], 'children'> & {
  /** 将itemWidth传入每个item */
  children: (itemWidth: number) => ReactNode;
  /** 每个item最小的宽度 */
  minItemWidth: number;
  /** item间距，不需要间距可以传0（不要在样式中传入gap，会被覆盖） */
  itemGap: number;
  /** 如果dataSource数量不足以展示一排，是否用空白来补全（默认true，请在storybook查看演示） */
  complementWhenInsufficient?: boolean;
};

/**
 * - 响应式栅格布局
 */
export const ResponsiveGridLayout = (props: Props) => {
  // props
  const {
    minItemWidth,
    itemGap,
    complementWhenInsufficient = true,
    children,
    className,
    style,
    ...restProps
  } = props;
  // refs
  const containerRef = useRef<HTMLDivElement>(null);
  // custom hooks
  const { itemWidth } = useResponsiveItemWidth({
    containerRef,
    minItemWidth,
    gap: itemGap,
  });

  const containerStyle = useMemo<CSSProperties>(() => {
    const rule = complementWhenInsufficient ? 'auto-fill' : 'auto-fit';
    return {
      ...style,
      gridTemplateColumns: `repeat(${rule}, minmax(${minItemWidth}px, 1fr))`,
      gap: itemGap,
    };
  }, [complementWhenInsufficient, itemGap, minItemWidth, style]);

  return (
    <div
      {...restProps}
      className={classNames('grid w-full scroll-smooth', className)}
      ref={containerRef}
      style={containerStyle}
    >
      {children(itemWidth)}
    </div>
  );
};
