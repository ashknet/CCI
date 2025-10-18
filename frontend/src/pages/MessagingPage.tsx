import { useState, useEffect } from 'react'
import { messagingServiceClient } from '../config/api'

const MessagingPage = () => {
  const [threads, setThreads] = useState<any[]>([])
  const [selectedThread, setSelectedThread] = useState<any>(null)
  const [messages, setMessages] = useState<any[]>([])
  const [newMessage, setNewMessage] = useState('')
  const [loading, setLoading] = useState(false)

  useEffect(() => {
    fetchThreads()
  }, [])

  useEffect(() => {
    if (selectedThread) {
      fetchMessages(selectedThread.id)
    }
  }, [selectedThread])

  const fetchThreads = async () => {
    try {
      const response = await messagingServiceClient.get('/api/v1/messages/threads')
      setThreads(response.data.data.items)
    } catch (error) {
      console.error('Failed to fetch threads', error)
    }
  }

  const fetchMessages = async (threadId: string) => {
    try {
      const response = await messagingServiceClient.get(`/api/v1/messages/threads/${threadId}`)
      setMessages(response.data.data)
    } catch (error) {
      console.error('Failed to fetch messages', error)
    }
  }

  const handleSendMessage = async (e: React.FormEvent) => {
    e.preventDefault()
    if (!newMessage.trim() || !selectedThread) return

    setLoading(true)
    try {
      await messagingServiceClient.post(`/api/v1/messages/threads/${selectedThread.id}/messages`, {
        content: newMessage
      })
      setNewMessage('')
      fetchMessages(selectedThread.id)
    } catch (error) {
      console.error('Failed to send message', error)
    } finally {
      setLoading(false)
    }
  }

  const formatTime = (dateString: string) => {
    const date = new Date(dateString)
    return date.toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })
  }

  return (
    <div className="max-w-7xl mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-6">Messages</h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-4 h-[calc(100vh-200px)]">
        {/* Threads List */}
        <div className="card overflow-y-auto">
          <h2 className="text-lg font-semibold mb-4 sticky top-0 bg-white pb-2">Conversations</h2>
          <div className="space-y-2">
            {threads.map((thread) => (
              <button
                key={thread.id}
                onClick={() => setSelectedThread(thread)}
                className={`w-full text-left p-3 rounded-lg transition-colors ${
                  selectedThread?.id === thread.id
                    ? 'bg-primary-100 border-primary-500'
                    : 'hover:bg-gray-50 border-transparent'
                } border-2`}
              >
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <h3 className="font-semibold text-sm">{thread.providerName}</h3>
                    <p className="text-xs text-gray-600 mt-1">{thread.subject}</p>
                  </div>
                  {thread.unreadCount > 0 && (
                    <span className="bg-primary-600 text-white text-xs rounded-full px-2 py-1">
                      {thread.unreadCount}
                    </span>
                  )}
                </div>
                <p className="text-xs text-gray-500 mt-2">
                  {thread.lastMessageAt ? formatTime(thread.lastMessageAt) : 'No messages'}
                </p>
              </button>
            ))}

            {threads.length === 0 && (
              <p className="text-gray-600 text-center py-8">No conversations yet</p>
            )}
          </div>
        </div>

        {/* Messages Panel */}
        <div className="lg:col-span-2 card flex flex-col">
          {selectedThread ? (
            <>
              {/* Thread Header */}
              <div className="border-b pb-4 mb-4">
                <h2 className="text-xl font-semibold">{selectedThread.providerName}</h2>
                <p className="text-sm text-gray-600">{selectedThread.subject}</p>
              </div>

              {/* Messages List */}
              <div className="flex-1 overflow-y-auto space-y-4 mb-4">
                {messages.map((message) => (
                  <div
                    key={message.id}
                    className={`flex ${message.senderType === 'patient' ? 'justify-end' : 'justify-start'}`}
                  >
                    <div
                      className={`max-w-[70%] rounded-lg p-3 ${
                        message.senderType === 'patient'
                          ? 'bg-primary-600 text-white'
                          : 'bg-gray-100 text-gray-900'
                      }`}
                    >
                      <p className="text-sm font-medium mb-1">{message.senderName}</p>
                      <p>{message.content}</p>
                      <p className="text-xs mt-2 opacity-75">{formatTime(message.createdAt)}</p>
                    </div>
                  </div>
                ))}

                {messages.length === 0 && (
                  <p className="text-gray-600 text-center py-8">No messages in this thread</p>
                )}
              </div>

              {/* Message Input */}
              <form onSubmit={handleSendMessage} className="border-t pt-4">
                <div className="flex space-x-2">
                  <input
                    type="text"
                    value={newMessage}
                    onChange={(e) => setNewMessage(e.target.value)}
                    placeholder="Type your message..."
                    className="flex-1 input-field"
                    disabled={loading}
                  />
                  <button
                    type="submit"
                    disabled={loading || !newMessage.trim()}
                    className="btn-primary"
                  >
                    {loading ? 'Sending...' : 'Send'}
                  </button>
                </div>
                <p className="text-xs text-gray-500 mt-2">
                  📎 Attach files (coming soon) • End-to-end encrypted
                </p>
              </form>
            </>
          ) : (
            <div className="flex-1 flex items-center justify-center text-gray-500">
              <div className="text-center">
                <p className="text-lg mb-2">💬</p>
                <p>Select a conversation to start messaging</p>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  )
}

export default MessagingPage
