import { IRecipientListItem } from "@/types";
import { writeToString } from "@fast-csv/format";

export const generateCsv = (recipients: IRecipientListItem[]) => {
  const headers = ["Name", "Status"];

  const rows = recipients.map((r: IRecipientListItem) => {
    return [r.name, r.status];
  });

  rows.unshift(headers);
  return writeToString(rows);
};

export const downloadCsv = (filename: string, csvData: string) => {
  const element = document.createElement("a");

  element.setAttribute("href", "data:text/csv;charset=utf-8," + encodeURIComponent(csvData));
  element.setAttribute("download", filename);
  element.style.display = "none";
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
};
