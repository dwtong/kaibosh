import { startOfDay, startOfWeek, format, addDays } from "date-fns";

export const listOfDays = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];
export const today = startOfDay(new Date());
export const thisWeek = startOfWeek(today, { weekStartsOn: 1 });

export const mondayOfWeek = (date: Date) => startOfWeek(date, { weekStartsOn: 1 });

export const formatDate = (date: Date, datePattern: string): string => {
  return format(new Date(date), datePattern, {});
};

export const dateOnDayOfWeek = (date: Date, day: string): Date => {
  const dayIndex = listOfDays.findIndex(d => d === day);
  return addDays(startOfWeek(date, { weekStartsOn: 1 }), dayIndex);
};

export { subWeeks, addWeeks } from "date-fns";
