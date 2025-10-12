import { useQuery } from '@tanstack/react-query'
import axios from 'axios'
import { useState } from 'react'
import { Link } from 'react-router-dom'

export default function SearchPage() {
  const [q, setQ] = useState('')
  const [city, setCity] = useState('')
  const { data, isLoading } = useQuery({
    queryKey: ['search', q, city],
    queryFn: async () => {
      const res = await axios.get(`/api/search?q=${encodeURIComponent(q)}&city=${encodeURIComponent(city)}`)
      return res.data
    }
  })

  return (
    <div style={{ padding: 24 }}>
      <h2>Find Doctors and Hospitals</h2>
      <input placeholder="Search doctor/hospital/disease" value={q} onChange={e=>setQ(e.target.value)} />
      <input placeholder="City" value={city} onChange={e=>setCity(e.target.value)} />
      {isLoading && <p>Loading...</p>}
      <div>
        {data?.providers?.map((p: any) => (
          <div key={p.DoctorId} style={{ border: '1px solid #ddd', margin: 8, padding: 8 }}>
            <div style={{ display: 'flex', justifyContent: 'space-between' }}>
              <div>
                <div><b>{p.FullName}</b> — {p.Specialty}</div>
                <div>{p.HospitalName} — {p.City}</div>
              </div>
              <Link to={`/book?doctorId=${p.DoctorId}`}>Book</Link>
            </div>
          </div>
        ))}
      </div>
    </div>
  )
}
