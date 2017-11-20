<template>
    <li class="card mb-3">
        <div class="card-body">
            <slot name="drag-handle"></slot>

            <h4 class="card-title">
                <router-link :to="`/stories/${data.identifier}`" class="link-unstyled">{{ data.title }}</router-link>
                <small class="text-muted">{{ data.identifier }}</small>
            </h4>
            <p class="card-text">
                <b-dropdown variant="link" no-caret class="b-dropdown-minimal">
                    <template slot="button-content">
                        <span class="badge" :class="statusMap[data.status].css">
                            {{ statusMap[data.status].name }}
                        </span>
                    </template>
                    <b-dropdown-item v-for="(status, index) in statusMap" :key="index"
                                     @click="saveStatus(index)">
                        <span class="badge" :class="[status.css]">{{ status.name }}</span>
                    </b-dropdown-item>
                </b-dropdown>

                <template>
                    <b-form-group v-if="showPointsField" class="points-form">
                        <b-form-input size="sm" id="story-points" type="number" min="0" v-model="points"></b-form-input>
                        <b-button size="sm" variant="primary" @click="savePoints">Save</b-button>
                        <b-button size="sm" @click="showPointsField = !showPointsField">Cancel</b-button>
                    </b-form-group>

                    <small v-else @click="showPointsField = !showPointsField">
                        {{ data.points ? data.points + ' SP' : 'not estimated' }}
                    </small>
                </template>
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
                showPointsField: false,
                newPoints: null,
            }
        },
        computed: {
            points: {
                get() {
                    return this.data.points;
                },
                set(points) {
                    this.newPoints = points || null;
                }
            }
        },
        methods: {
            /**
             * Save new status of story
             * @param statusId
             */
            saveStatus(statusId) {
                this.$store.dispatch('stories/patch', {
                    id: this.data.id,
                    field: 'status',
                    value: statusId,
                });
            },

            /**
             * Save points of story
             */
            savePoints() {
                this.$store.dispatch('stories/patch', {
                    id: this.data.id,
                    field: 'points',
                    value: this.newPoints,
                }).then(() => {
                    this.showPointsField = false;
                    this.newPoints = null;
                });
            },
        }
    }
</script>

<style lang="scss">
    .points-form {
        display: inline;

        input {
            display: inline;
            width: 4em;
        }
    }
</style>