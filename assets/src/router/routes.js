import ListRecipients from "@/views/ListRecipients";
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
    path: "*",
    component: NotFound
  }
];
