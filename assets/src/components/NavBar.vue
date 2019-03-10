<template>
  <aside class="menu">
    <div class="logo">
      <img src="@/assets/images/kaibosh.png" alt />
    </div>

    <p class="menu-label">Food Recipients</p>
    <ul class="menu-list">
      <li>
        <a class="is-active">View recipients</a>
      </li>
      <li>
        <a>Add new recipient</a>
      </li>
    </ul>

    <p class="menu-label">Schedule</p>
    <ul class="menu-list">
      <li>
        <a>View schedule</a>
      </li>
    </ul>
  </aside>
</template>

<style lang="scss" scoped>
.logo {
  margin: 1rem 1rem 2.5rem 2rem;
  width: 150px;
  text-align: center;
  h1 {
    color: white;
    font-size: 2.5rem;
  }
}

.menu-label {
  margin-top: 2.5rem !important;
  margin-left: 2.5rem;
  color: $primary;
  font-weight: 700;
}

.menu-list {
  a {
    &:hover {
      border-radius: 1rem 0 0 1rem;
      background-color: $primary;
      color: $text;
    }

    &.is-active {
      background-color: $background;
      color: $text;
      border-radius: 1rem 0 0 1rem;
      &:hover {
        border-radius: 1rem 0 0 1rem;
        background-color: $primary;
        color: $text;
      }
    }
    color: white;
    margin-left: 1rem;
    padding-left: 1.5rem;
    padding-top: 0.6rem;
    padding-bottom: 0.6rem;
    margin-top: 0.6rem;
    margin-bottom: 0.6rem;
  }
}
</style>
