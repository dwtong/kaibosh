import { createRouter, createWebHistory } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import CreateRecipientView from '@/views/recipients/CreateRecipientView.vue'
import UpdateRecipientView from '@/views/recipients/UpdateRecipientView.vue'
import SignupView from '@/views/recipients/SignupView.vue'
import ListRecipientsView from '@/views/recipients/ListRecipientsView.vue'
import ShowRecipientView from '@/views/recipients/ShowRecipientView.vue'
import ShowSessionView from '@/views/sessions/ShowSessionView.vue'
import ListSessionsView from '@/views/sessions/ListSessionsView.vue'
import PrintRecipientDescriptionsView from '@/views/sessions/PrintRecipientDescriptionsView.vue'
import ResetPasswordView from '@/views/users/ResetPasswordView.vue'
import SettingsView from '@/views/users/SettingsView.vue'
import LoginView from '@/views/users/LoginView.vue'
import NotFoundView from '@/views/NotFoundView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      redirect: '/sessions/week',
    },
    {
      path: '/login',
      component: LoginView,
      meta: { public: true },
    },
    {
      path: '/signup',
      component: SignupView,
      meta: { public: true },
    },
    {
      path: '/recipients',
      component: ListRecipientsView,
    },
    {
      path: '/recipients/new',
      component: CreateRecipientView,
    },
    {
      path: '/recipients/:id',
      component: ShowRecipientView,
      props: true,
    },
    {
      path: '/recipients/update/:id',
      component: UpdateRecipientView,
      props: true,
    },
    {
      path: '/sessions/week',
      component: ListSessionsView,
      props: true,
    },
    {
      path: '/sessions/:id',
      component: ShowSessionView,
      props: true,
    },
    {
      path: '/sessions/:id/descriptions',
      component: PrintRecipientDescriptionsView,
      props: true,
    },
    {
      path: '/settings',
      component: SettingsView,
      props: true,
    },
    {
      path: '/reset_password',
      component: ResetPasswordView,
      // beforeEnter: saveResetParams,
      props: true,
    },
    {
      component: NotFoundView,
      path: '/:pathmatch(.*)*',
    },
  ],
})

router.beforeEach((to) => {
  const auth = useAuthStore()

  if (!to.meta.public && !auth.isAuthenticated) {
    return {
      path: '/login',
      query: { redirect: to.fullPath },
    }
  }
})

export default router
