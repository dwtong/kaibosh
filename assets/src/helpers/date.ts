export default {
  getMonday(date: Date): Date {
    const day = date.getDay() || 7;

    if (day !== 1) {
      date.setHours(-24 * (day - 1));
    }

    return date;
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
