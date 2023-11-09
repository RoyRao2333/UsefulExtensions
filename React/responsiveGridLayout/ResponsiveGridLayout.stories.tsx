/* eslint-disable @typescript-eslint/no-explicit-any */
import React from 'react';
import { Meta, StoryObj } from '@storybook/react';
import { ResponsiveGridLayout } from './ResponsiveGridLayout';

const meta: Meta<typeof ResponsiveGridLayout> = {
  title: 'base-ui/Layout/ResponsiveGridLayout',
  component: ResponsiveGridLayout,
};

export default meta;

type Story = StoryObj<typeof ResponsiveGridLayout>;

export const 常规用法: Story = {
  render: () => {
    return (
      <ResponsiveGridLayout minItemWidth={200} itemGap={16}>
        {(itemWidth) => {
          return Array.from({ length: 20 }, (_, index) => index).map((val) => {
            return (
              <div
                key={val}
                className="bg-primary-hover text-center text-white"
                style={{ width: itemWidth }}
              >
                {val}
              </div>
            );
          });
        }}
      </ResponsiveGridLayout>
    );
  },
};

export const 不够一行时使用空白补充: Story = {
  render: () => {
    return (
      <ResponsiveGridLayout
        minItemWidth={200}
        itemGap={16}
        complementWhenInsufficient
      >
        {(itemWidth) => {
          return Array.from({ length: 3 }, (_, index) => index).map((val) => {
            return (
              <div
                key={val}
                className="bg-primary-hover text-center text-white"
                style={{ width: itemWidth }}
              >
                {val}
              </div>
            );
          });
        }}
      </ResponsiveGridLayout>
    );
  },
};

export const 不够一行时无限拉伸: Story = {
  render: () => {
    return (
      <ResponsiveGridLayout
        minItemWidth={200}
        itemGap={16}
        complementWhenInsufficient={false}
      >
        {(itemWidth) => {
          return Array.from({ length: 3 }, (_, index) => index).map((val) => {
            return (
              <div
                key={val}
                className="bg-primary-hover text-center text-white"
                style={{ width: itemWidth }}
              >
                {val}
              </div>
            );
          });
        }}
      </ResponsiveGridLayout>
    );
  },
};
