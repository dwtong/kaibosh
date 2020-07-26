<template>
  <span>{{ session.day | capitalize }} - {{ session.time | formatTime }}</span>
</template>

<script lang="ts">
import { Component, Prop } from "vue-property-decorator";
import Vue from "vue";
import { formatTime } from "@/helpers/date";
import { capitalize } from "lodash";
import { IRecipientSession } from "@/types";

@Component({ filters: { capitalize, formatTime } })
export default class SessionLabel extends Vue {
  @Prop() readonly session!: IRecipientSession;
}
</script>
