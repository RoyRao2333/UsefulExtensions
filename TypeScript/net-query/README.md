# `TanStack Query`组件指南

## `useQuery`

> 1. 需要在App最外层包裹`NetQueryProvider`
> 2. `NetQueryProvider`需接收一个`INetworking`实例，由项目各自创建后传入

### 直接构造`YTRequest`，当参数变化时（例如这里的`userId`），会触发`useQuery`的重新请求

```tsx
const [userId, setUserId] = useState<number>();

const { data, isLoading } = useQuery(xxxApi({ userId }));
```

### 传入api的构造方法，则`useQuery`不依赖外部参数。在初次请求之后，不会再重新请求，可手动执行`reloadData`以更新`data`（参数不变）

```tsx
const { data, reloadData } = useQuery(xxxApi);

return <Button onClick={() => { reloadData() }}>{data?.text}</Button>
```

### 顺序调用时，如果后面的请求需要依赖前面请求的返回值，有两种解决方案

```tsx
const [userId, setUserId] = useState<number>();

const { data: data1 } = useQuery(xxxApi({ userId }));

// 1. 请求传入`null`，则不会触发请求
const { data: data2 } = useQuery(data1?.id ? yyyApi({ id: data1.id }) : null);

// 2. `queryOptions`中的`enabled`为`false`时，不会触发请求
const { data: data3 } = useQuery(
    zzzApi({ id: Number(data1?.id) }), 
    { queryOptions: { enabled: !!data1?.id } }
);
```

## `useMutation`

> TODO: 待完善