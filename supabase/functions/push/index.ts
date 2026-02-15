// supabase/functions/push/index.ts
import { createClient } from 'npm:@supabase/supabase-js@2'
import { JWT } from 'npm:google-auth-library@9'
import serviceAccount from '../service-account.json' with { type: 'json' }

interface Message {
  id: string
  chat_id: string
  sender_id: string
  content: string
  created_at: string
  is_read: boolean
}

interface WebhookPayload {
  type: 'INSERT'
  table: 'messages'
  record: Message
  schema: 'public'
}

const supabase = createClient(
  Deno.env.get('SUPABASE_URL')!,
  Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
)

Deno.serve(async (req) => {
  try {
    const payload: WebhookPayload = await req.json()
    console.log('📨 New message webhook:', JSON.stringify(payload, null, 2))
    
    const message = payload.record
    
    const { data: members, error: membersError } = await supabase
      .from('chat_members')
      .select('user_id')
      .eq('chat_id', message.chat_id)
    
    if (membersError || !members || members.length === 0) {
      console.error('❌ No chat members found')
      return new Response(
        JSON.stringify({ error: 'Chat members not found' }),
        { status: 404 }
      )
    }
    
    const receiverId = members
      .map(m => m.user_id)
      .find(id => id !== message.sender_id)
    
    if (!receiverId) {
      console.log('⚠️ No receiver found (maybe message to self?)')
      return new Response(
        JSON.stringify({ message: 'No receiver needed' }),
        { status: 200 }
      )
    }
    
    const { data: receiver, error: userError } = await supabase
      .from('users')
      .select('fcm_token, name')
      .eq('id', receiverId)
      .single()
    
    if (userError || !receiver) {
      console.error('❌ Receiver not found:', receiverId)
      return new Response(
        JSON.stringify({ error: 'Receiver not found' }),
        { status: 404 }
      )
    }
    
    if (!receiver.fcm_token) {
      console.log('⚠️ No FCM token for receiver:', receiverId)
      return new Response(
        JSON.stringify({ message: 'No FCM token' }),
        { status: 200 }
      )
    }
    
    const { data: sender } = await supabase
      .from('users')
      .select('name')
      .eq('id', message.sender_id)
      .single()
    
    console.log('📱 Sending push to receiver:', receiverId)
    console.log('📱 FCM token:', receiver.fcm_token.substring(0, 20) + '...')
    
    const accessToken = await getAccessToken({
      clientEmail: serviceAccount.client_email,
      privateKey: serviceAccount.private_key,
    })
    
    const fcmResponse = await fetch(
      `https://fcm.googleapis.com/v1/projects/${serviceAccount.project_id}/messages:send`,
      {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Authorization': `Bearer ${accessToken}`,
        },
        body: JSON.stringify({
          message: {
            token: receiver.fcm_token,
            notification: {
              title: sender?.name || 'New Message',
              body: message.content,
            },
            data: {
              type: 'chat',
              chatId: message.chat_id,
              messageId: message.id,
              senderId: message.sender_id,
              receiverId: receiverId,
              click_action: 'FLUTTER_NOTIFICATION_CLICK',
            },
            android: {
              priority: 'high',
              notification: {
                clickAction: 'FLUTTER_NOTIFICATION_CLICK',
                channelId: 'chat_messages',
              },
            },
            apns: {
              payload: {
                aps: {
                  sound: 'default',
                  category: 'NEW_MESSAGE',
                },
              },
            },
          },
        }),
      }
    )
    
    const fcmData = await fcmResponse.json()
    
    if (!fcmResponse.ok) {
      console.error('❌ FCM error:', fcmData)
      return new Response(
        JSON.stringify({ error: fcmData }),
        { status: fcmResponse.status }
      )
    }
    
    console.log('✅ Push notification sent successfully to:', receiverId)
    
    return new Response(
      JSON.stringify({ 
        success: true, 
        messageId: fcmData.name,
        receiverId: receiverId 
      }),
      { status: 200 }
    )
    
  } catch (error) {
    console.error('❌ Unexpected error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500 }
    )
  }
})

const getAccessToken = ({
  clientEmail,
  privateKey,
}: {
  clientEmail: string
  privateKey: string
}): Promise<string> => {
  return new Promise((resolve, reject) => {
    const jwtClient = new JWT({
      email: clientEmail,
      key: privateKey,
      scopes: ['https://www.googleapis.com/auth/firebase.messaging'],
    })
    
    jwtClient.authorize((err, tokens) => {
      if (err) {
        console.error('❌ JWT error:', err)
        reject(err)
        return
      }
      resolve(tokens!.access_token!)
    })
  })
}