import CreateRecipient from "@/views/CreateRecipient.vue";
import UpdateRecipient from "@/views/UpdateRecipient.vue";
import ListRecipients from "@/views/ListRecipients.vue";
import NotFound from "@/views/NotFound.vue";
import ShowRecipient from "@/views/ShowRecipient.vue";

export default [
  {
    path: "/",
    redirect: "/recipients"
  },
  {
    component: ListRecipients,
    path: "/recipients"
  },
  {
    component: CreateRecipient,
    path: "/recipients/new"
  },
  {
    component: ShowRecipient,
    path: "/recipients/:id",
    props: true
  },
  {
    component: UpdateRecipient,
    path: "/recipients/update/:id",
    props: true
  },
  {
    component: NotFound,
    path: "*"
  }
];
