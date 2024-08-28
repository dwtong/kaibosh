import { endOfDay, startOfDay, startOfWeek, format, addDays } from "date-fns"

export const listOfDays = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
] as const
export type Day = (typeof listOfDays)[number]
export const today = startOfDay(new Date())
export const thisWeek = startOfWeek(today, { weekStartsOn: 1 })

export const startOfDayString = (date: Date) => startOfDay(date).toISOString()
export const endOfDayString = (date: Date) => endOfDay(date).toISOString()
export const mondayOfWeek = (date: Date) =>
  startOfWeek(date, { weekStartsOn: 1 })

export const formatDate = (
  date: Date | string,
  datePattern = "d/M/yyyy",
): string => {
  return format(new Date(date), datePattern, {})
}

export const formatTime = (time: string): string => {
  const date = new Date(`1970-01-01T${time}`)
  return format(date, "h:mm a", {})
}

export const dayIndexFromString = (day: string): number => {
  const days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ]
  return days.indexOf(day)
}

export const dateOnDayOfWeek = (date: Date, day: Day): Date => {
  const dayIndex = listOfDays.findIndex((d) => d === day)
  return addDays(startOfWeek(date, { weekStartsOn: 1 }), dayIndex)
}

export { subWeeks, addWeeks } from "date-fns"
