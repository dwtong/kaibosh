import { ref } from 'vue'
import { defineStore } from 'pinia'
import { getRecipients } from '@/api/recipients'

export const useRecipientsStore = defineStore('recipients', () => {
  const recipients = ref()

  async function fetchRecipients() {
    await getRecipients().then((data) => (recipients.value = data))
  }

  return { fetchRecipients, recipients }
})
