import CreateRecipient from "@/views/CreateRecipient";
import ListRecipients from "@/views/ListRecipients";
import ShowRecipient from "@/views/ShowRecipient";
import NotFound from "@/views/NotFound";

export default [
  {
    path: "/",
    redirect: "/recipients"
  },
  {
    path: "/recipients",
    component: ListRecipients
  },
  {
    path: "/recipients/new",
    component: CreateRecipient
  },
  {
    path: "/recipients/:id",
    component: ShowRecipient,
    props: true
  },
  {
    path: "*",
    component: NotFound
  }
];
