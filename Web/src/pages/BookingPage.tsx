import { useEffect, useMemo } from 'react'
import { useSearchParams } from 'react-router-dom'
import { useQuery } from '@tanstack/react-query'
import axios from 'axios'

export default function BookingPage() {
  const [params] = useSearchParams()
  const doctorId = useMemo(()=> Number(params.get('doctorId')), [params])
  const { data } = useQuery({
    queryKey: ['availability', doctorId],
    enabled: !!doctorId,
    queryFn: async () => {
      const now = new Date()
      const from = new Date(now.getTime() + 24*3600*1000)
      const to = new Date(now.getTime() + 7*24*3600*1000)
      const res = await axios.get(`/api/appointments/availability`, {
        params: { doctorId, from: from.toISOString(), to: to.toISOString() }
      })
      return res.data
    }
  })

  useEffect(()=>{
    if(!doctorId) return
  },[doctorId])

  return (
    <div style={{ padding: 24 }}>
      <h2>Choose a slot</h2>
      <ul>
        {data?.map((s:any)=> (
          <li key={s.Id}>{new Date(s.StartAtUtc).toLocaleString()} - {new Date(s.EndAtUtc).toLocaleString()}</li>
        ))}
      </ul>
    </div>
  )
}
