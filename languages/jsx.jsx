import React, { useCallback, useEffect, useMemo, useRef, useState } from 'react'
import * as Icons from './icons'
import Panel from './Panel'

const SLUG = /^[a-z]+(\d{2,4})?$/gi

/**
 * @param {string} url
 */
function useFetch(url) {
  const [data, setData] = useState(null)
  const hits = useRef(0)
  useEffect(() => {
    hits.current += 1
    fetch(`${url}?v=${hits.current}`).then((r) => setData(r?.body ?? []))
    return () => setData(null)
  }, [url])
  return { data, hits }
}

const Badge = ({ label = 'new', hot, ...rest }) => (
  <span className="badge" style={{ color: hot ? 'red' : '#888' }} {...rest}>
    {label} &amp; more
  </span>
)

class Legacy extends React.Component {
  state = { open: false }
  componentDidMount() {
    this.setState({ open: true })
  }
  render() {
    const { open } = this.state
    return <Panel.Header title={this.props.title}>{open && 'live'}</Panel.Header>
  }
}
Legacy.defaultProps = { title: 'x' }

export default function App({ items = [], user }) {
  const { data } = useFetch('/api')
  const [q, setQ] = useState('')
  const rows = useMemo(() => [...items, { id: 0, q }], [items, q])
  const onSave = useCallback(
    async (e) => {
      e.preventDefault()
      await fetch('/save', { method: 'POST', [`x-${q}`]: 1 })
    },
    [q],
  )

  return (
    <>
      {/* comment */}
      <Icons.Arrow.Left size={16} aria-hidden />
      <form onSubmit={onSave} data-test={`app-${q}`}>
        <input value={q} onChange={(e) => setQ(e.target.value)} autoFocus />
        <hr />
        {user ? <Badge label={user.name} hot /> : <Badge />}
        {data?.length > 0 && <em>{SLUG.test(q) ? 'ok' : 'no'}</em>}
        <React.Fragment>
          <ul>
            {rows.map((row) => (
              <li key={row.id}>{row.q ?? '-'}</li>
            ))}
          </ul>
        </React.Fragment>
      </form>
      <Legacy title="last" />
    </>
  )
}
