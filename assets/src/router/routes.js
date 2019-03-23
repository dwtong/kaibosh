import ListRecipients from "@/views/ListRecipients";
import CreateRecipient from "@/views/CreateRecipient";
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
    path: "*",
    component: NotFound
  }
];
