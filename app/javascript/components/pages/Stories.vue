<template>
    <section id="stories">
        <h1>Backlog</h1>

        <ul v-sortable="{handle: '.js-drag-drop', onEnd: saveOrder}" class="mt-3 pl-0">
            <li class="card mb-3" v-for="story in stories" :key="story.id">
                <div class="card-body">
                    <span class="js-drag-drop float-right p-1">
                        <icon name="bars" label="Drag and drop to change order"></icon>
                    </span>

                    <h4 class="card-title"><router-link :to="`/stories/${story.identifier}`" class="link-unstyled">{{ story.title }}</router-link>
                        <small class="text-muted">{{ story.identifier }}</small>
                    </h4>
                    <p class="card-text">
                        <b-dropdown size="sm" variant="link" no-caret class="b-dropdown-minimal">
                            <template slot="button-content">
                                <span class="badge" :class="statusMap[story.status].css">
                                    {{ statusMap[story.status].name }}
                                </span>
                            </template>
                            <b-dropdown-item v-for="(status, index) in statusMap" :key="index"
                                             @click="saveStatus(story.id, index)">
                                <span class="badge" :class="[status.css]">{{ status.name }}</span>
                            </b-dropdown-item>
                        </b-dropdown>
                    </p>
                    <p class="card-text" v-if="story.description">
                        {{ story.description }}
                    </p>
                </div>
            </li>
        </ul>

        <b-form v-if="showForm" @submit="saveStory">
            <b-row>
                <b-col md="10">
                    <b-form-group label="Story *" label-for="story-title">
                        <b-form-input id="story-title" v-model="newStory.title" required></b-form-input>
                    </b-form-group>
                </b-col>
                <b-col md="2">
                    <b-form-group label="Story points" label-for="story-points">
                        <b-form-input id="story-points" type="number" min="0" v-model="newStory.points"></b-form-input>
                    </b-form-group>
                </b-col>
            </b-row>

            <b-form-group label="Notes" label-for="story-description">
                <b-form-textarea id="story-description" v-model="newStory.description"></b-form-textarea>
            </b-form-group>

            <b-button type="submit" variant="primary" :disabled="$v.newStory.$invalid">Save</b-button>
            <b-button type="button" variant="secondary" @click="showForm = false">Cancel</b-button>
        </b-form>

        <b-button v-else type="button" variant="primary" @click="showForm = true">Add story</b-button>
    </section>
</template>

<script>
    import {required, numeric, minValue} from 'vuelidate/lib/validators';

    export default {
        data() {
            return {
                showForm: false,
                newStory: {},
                statusMap: this.$store.state.stories.statusMap,
            };
        },
        computed: {
            stories() {
                return this.$store.getters['stories/all'];
            }
        },
        methods: {
            /**
             * Save current form state as new story
             */
            saveStory() {
                if (this.$v.newStory.$invalid) {
                    this.$v.newStory.$touch();
                    return;
                }

                this.$store.dispatch('stories/save', {
                    story: this.newStory
                }).then(() => {
                    this.newStory = {};
                });
            },

            /**
             * Save new position of dragged story
             * @param evt
             */
            saveOrder(evt) {
                this.$store.dispatch('stories/reorder', {
                    oldIndex: evt.oldIndex,
                    newIndex: evt.newIndex,
                });
            },

            /**
             * Save new status of story
             * @param storyId
             * @param statusId
             */
            saveStatus(storyId, statusId) {
                this.$store.dispatch('stories/patch', {
                    id: storyId,
                    field: 'status',
                    value: statusId,
                });
            }
        },
        validations: {
            newStory: {
                title: {required},
                points: {numeric, minValue: minValue(0)}
            },
        },
    };
</script>

<style scoped>

</style>
