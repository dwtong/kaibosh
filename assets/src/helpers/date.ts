export default {
  getMonday(date: Date): Date {
    const day = date.getDay() || 7;

    if (day !== 1) {
      date.setHours(-24 * (day - 1));
    }

    return date;
  },

  getISODate(date: Date): string {
    const year = date.getFullYear().toString();

    let month = (date.getMonth() + 1).toString();
    month = month.length === 1 ? `0${month}` : month;

    let day = date.getDate().toString();
    day = day.length === 1 ? `0${day}` : day;

    return `${year}-${month}-${day}`;
  },

  days: [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ]
};
