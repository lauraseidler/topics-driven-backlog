<template>
    <li class="card mb-3">
        <div class="card-body">
            <slot name="drag-handle"></slot>

            <h4 class="card-title">
                <router-link :to="`/stories/${data.identifier}`" class="link-unstyled">{{ data.title }}</router-link>
                <small class="text-muted">{{ data.identifier }}</small>
            </h4>
            <p class="card-text">
                <b-dropdown size="sm" variant="link" no-caret class="b-dropdown-minimal">
                    <template slot="button-content">
                        <span class="badge" :class="statusMap[data.status].css">
                            {{ statusMap[data.status].name }}
                        </span>
                    </template>
                    <b-dropdown-item v-for="(status, index) in statusMap" :key="index"
                                     @click="saveStatus(data.id, index)">
                        <span class="badge" :class="[status.css]">{{ status.name }}</span>
                    </b-dropdown-item>
                </b-dropdown>
            </p>
            <p class="card-text" v-if="data.description">
                {{ data.description }}
            </p>
        </div>
    </li>
</template>

<script>
    export default {
        name: 'story',
        props: ['data'],
        data() {
            return {
                statusMap: this.$store.state.stories.statusMap,
            }
        },
        methods: {
            /**
             * Save new status of story
             * @param id
             * @param statusId
             */
            saveStatus(id, statusId) {
                this.$store.dispatch('stories/patch', {
                    id: id,
                    field: 'status',
                    value: statusId,
                });
            },
        }
    }
</script>