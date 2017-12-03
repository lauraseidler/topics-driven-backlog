<template>
    <tr>
        <td v-if="editing" colspan="5">
            <story-form v-model="editingData" @cancel="editing = false" @submit="save"></story-form>
        </td>

        <template v-else>
            <!-- Drag and drop -->
            <td v-if="isView('backlog')">
                <span class="js-drag-drop">
                    <icon name="arrows" label="Drag and drop to change order"></icon>
                </span>
                {{ data.position }}
            </td>

            <!-- Identifier -->
            <td>
                {{ data.identifier }}
            </td>

            <!-- Story -->
            <td>
                {{ data.title }}
            </td>

            <!-- Story points -->
            <td>
                {{ data.points ? data.points + ' SP' : 'not&nbsp;estimated' }}
            </td>

            <!-- Sprint -->
            <td v-if="isView('history')">

            </td>

            <!-- Status -->
            <td v-if="isView(['sprint', 'history'])">
                <b-dropdown variant="link" no-caret class="b-dropdown-minimal">
                    <template slot="button-content">
                        <span class="badge" :class="statusMap[data.status].css">
                            {{ statusMap[data.status].name }}
                        </span>
                    </template>
                    <b-dropdown-item v-for="(status, index) in statusMap" :key="index" @click="saveStatus(index)">
                        <span class="badge" :class="[status.css]">{{ status.name }}</span>
                    </b-dropdown-item>
                </b-dropdown>
            </td>

            <td v-if="isView('backlog')">
                <b-button size="sm" variant="primary" title="Edit" @click="startEditing">
                    <icon name="pencil"></icon>
                </b-button>
                <b-button size="sm" variant="danger" title="Delete" @click="remove">
                    <icon name="trash"></icon>
                </b-button>
            </td>

            <td v-if="isView('planning')">
                <b-button size="sm" variant="primary" title="Add to sprint" @click="addToSprint">
                    <icon name="plus"></icon>
                </b-button>
            </td>
        </template>
    </tr>
</template>

<script>
    import * as _ from "lodash";
    import StoryForm from "../forms/StoryForm.vue";

    export default {
        components: {StoryForm},
        name: 'story',
        props: ['data', 'view'],
        data() {
            return {
                editing: false,
                editingData: null,
                statusMap: this.$store.state.stories.statusMap,
            }
        },
        methods: {
            /**
             * Check if we're operating in a given view
             * @param view
             */
            isView(view) {
                if (Array.isArray(view)) {
                    return view.indexOf(this.view) > -1;
                } else {
                    return this.view === view;
                }
            },

            /**
             * Start editing process of this story
             */
            startEditing() {
                this.editing = true;
                this.editingData = _.pick(this.data, ['title', 'description', 'points']);
            },

            /**
             * Save the edited parameters of this story
             */
            save() {
                this.$store.dispatch('stories/patch', {
                    id: this.data.id,
                    values: this.editingData,
                }).then(() => {
                    this.editing = false;
                });
            },

            /**
             * Delete this story
             */
            remove() {
                this.$store.dispatch('stories/delete', {
                    id: this.data.id,
                });
            },


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
        },
    };
</script>