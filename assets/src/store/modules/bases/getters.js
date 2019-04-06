export default {
  getBaseById(state) {
    return id => {
      const base = state.bases.data.find(base => base.id === id);
      if (base) {
        return base;
      } else {
        return { sessions: [] };
      }
    };
  }
};
