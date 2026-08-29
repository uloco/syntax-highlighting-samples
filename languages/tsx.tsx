import React, { forwardRef, useRef, useState, type MouseEvent, type ReactNode } from 'react'

enum Level {
  Low,
  High = 1 << 4,
}

interface Row {
  id: number
  name?: string
}

interface Props<T> {
  readonly items: T[]
  label?: string
  children: ReactNode
}

type Loose = { [extra: string]: unknown }
type Size = 'sm' | 'lg'
type EventName = `on${Capitalize<Size>}`
type Flags<T> = { readonly [K in keyof T]?: boolean }
type Keyed<T extends Row, F = Size> = Pick<T, 'id'> & { flag: F }
type Action = { kind: 'add'; value: number } | { kind: 'clear' }

const THEME = { size: 'lg', level: Level.High } as const
const marks = { id: true } satisfies Flags<Row>
const bag: Loose = { seed: 0x1f }
const handler: EventName = 'onSm'

function isAdd(a: Action): a is Extract<Action, { kind: 'add' }> {
  return a.kind === 'add'
}

const identity = <T,>(v: T): T => v

function reduce(a: Action): number {
  switch (a.kind) {
    case 'add':
      return isAdd(a) ? a.value : 0
    default:
      return 0
  }
}

const Field = forwardRef<HTMLInputElement, Partial<Omit<Props<Row>, 'children'>>>(
  ({ label }, ref) => <input ref={ref} placeholder={label} />,
)

function List<T extends Row>({ items, children }: Props<T>) {
  const box = useRef<HTMLDivElement>(null!)
  const [sel, setSel] = useState<Keyed<T> | null>(null)
  let total!: number

  const pick = (e: MouseEvent<HTMLButtonElement>) => {
    e.stopPropagation()
    total = reduce({ kind: 'add', value: items.length })
    setSel({ id: items[0]?.id, flag: THEME.size } as Keyed<T>)
    box.current?.scrollTo?.(0, total)
  }

  type ThemeKey = keyof typeof THEME
  const key: ThemeKey = 'size'

  return (
    <div ref={box} data-marks={marks.id} data-bag={String(bag.seed)}>
      <Field label={sel?.flag ?? handler} />
      <button onClick={pick}>{identity<ThemeKey>(key)}</button>
      {children}
    </div>
  )
}

const Wrapper: React.FC<{ level?: Level }> = ({ level = Level.Low }) => (
  <List<Row> items={[{ id: level as number }]}>ok</List>
)

export default Wrapper
