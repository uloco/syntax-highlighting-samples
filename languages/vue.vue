<script setup lang="ts">
import { computed, onMounted, ref, watch } from 'vue'
import BaseCard from './BaseCard.vue'
import IconStar from './IconStar.vue'
import type { Ref } from 'vue'

type Status = 'idle' | 'busy' | 'gone'
interface Item {
  id: number
  label?: string
}

const props = withDefaults(defineProps<{ items: Item[]; status?: Status }>(), {
  status: 'idle',
})
const emit = defineEmits<{ (e: 'pick', id: number): void; (e: 'close'): void }>()

const count: Ref<number> = ref(0)
const active = ref(true)
const attr = ref('data-idx')
const total = computed(() => props.items.length * count.value)
const html = `<b>${props.status}</b> &mdash; ${total.value}`

function first<T extends Item>(list: T[]): T | undefined {
  return list?.[0]
}

async function load(): Promise<void> {
  const res = await fetch(`/api/items?n=${count.value}`)
  count.value = (await res.json())?.total ?? 0
}

watch(count, (next, prev) => console.log(next > prev))
onMounted(load)
</script>

<template>
  <!-- comment -->
  <BaseCard v-bind="$attrs" :title="props.status" v-bind:id="attr" disabled>
    <template #header>
      <h1 :class="['card', { active }]" :style="{ color: 'red', '--gap': '4px' }">
        {{ first(props.items)?.label ?? 'none' }}
      </h1>
    </template>
    <IconStar />
    <input v-model.trim="attr" v-focus :[attr]="count" />
    <p v-if="count > 1">many</p>
    <p v-else-if="count === 1">one</p>
    <p v-else v-html="html" />
    <ul>
      <li
        v-for="(item, i) in props.items"
        :key="item.id"
        @click.prevent.stop="emit('pick', item.id)"
      >
        {{ i }}: {{ item.label?.toUpperCase() }}
      </li>
    </ul>
    <button @click="count++">+{{ total }}</button>
    <slot name="extra" :total="total" />
  </BaseCard>
</template>

<style scoped lang="scss">
@use 'sass:color';
$brand: #ff0055;
@mixin pad($n: 4px) { padding: $n; }
.card {
  --gap: 8px;
  @include pad(12px);
  gap: var(--gap);
  color: color.adjust($brand, $lightness: 10%);
  &:hover > .title { text-decoration: underline; }
  :deep(.inner) { margin: 0; }
  @media (min-width: 600px) { display: flex; }
}
</style>
