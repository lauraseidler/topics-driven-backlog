<template>
    <tr :class="{ [$style.highlight]: highlight || sortable && keyboardSorting, 'story-item': true }">
        <td 
            v-if="editing" 
            colspan="6">

            <StoryForm
                :project="project"
                v-model="editingData" 
                @cancel="cancelEdit"
                @submit="save"/>
        </td>

        <template v-else>
            <!-- Drag and drop -->
            <td v-if="isView(['backlog', 'planning-sprint', 'planning-backlog'])">
                <BButton
                        v-if="isView('planning-backlog')"
                        size="sm"
                        variant="primary"
                        title="Add to sprint"
                        @click="addToSprint">

                    <VIcon name="arrow-up"/>
                </BButton>

                <BButton
                        v-if="isView('planning-sprint')"
                        size="sm"
                        variant="danger"
                        title="Remove from sprint"
                        @click="removeFromSprint">

                    <VIcon name="arrow-down"/>
                </BButton>

                <span
                    :class="{ 'js-drag-drop': sortable, 'ml-2': true }"
                    v-if="isView(['backlog', 'planning-sprint'])"
                    @dblclick="!sortable || startKeyboardSort()"
                    :title="sortable ? 'Drag to change order, double click to use keyboard' : 'Sort by position ascending (default order) to be able to change order'">
                    <nobr>
                        <VIcon
                            name="arrows"
                            label="Drag and drop to change order"
                            :class="{ [$style.fade]: !sortable }"/>

                        <strong>{{ position }}</strong>
                    </nobr>
                </span>

                <strong v-if="isView('planning-backlog')">
                    {{ position }}
                </strong>
            </td>

            <td v-if="isView(['sprint', 'history'])">
                <strong>
                    {{ position }}
                </strong>
            </td>
            <!-- Identifier -->
            <td>
                {{ data.identifier }}
            </td>

            <!-- Story -->
            <td @click="expandedView = !expandedView">
                {{ data.title }}

                <p v-show="expandedView" class="mt-2">
                    Notes: <br>
                    {{ data.description || '(no notes)' }}
                </p>
            </td>

            <td>
                {{ topic(data.topic_id) ? topic(data.topic_id).title : '(no topic)' }}
            </td>

            <!-- Story points -->
            <td>
                {{ data.points ? data.points + ' SP' : '(not&nbsp;estimated)' }}
            </td>

            <!-- Status -->
            <td v-if="isView('history')">
                <span 
                    class="badge" 
                    :class="statusMap[data.status].css">
                    {{ statusMap[data.status].name }}
                </span>
            </td>

            <td v-if="isView('sprint')">
                <BDropdown 
                    variant="link" 
                    no-caret 
                    class="b-dropdown-minimal">

                    <template slot="button-content">
                        <span 
                            class="badge" 
                            :class="statusMap[data.status].css">
                            {{ statusMap[data.status].name }}
                        </span>
                    </template>

                    <BDropdownItem 
                        v-for="(status, index) in statusMap" 
                        :key="index" 
                        @click="saveStatus(index)">

                        <span 
                            class="badge" 
                            :class="[status.css]">{{ status.name }}</span>
                    </BDropdownItem>
                </BDropdown>
            </td>

            <td v-if="isView('backlog')">
                <BButton 
                    size="sm" 
                    variant="primary" 
                    title="Edit" 
                    @click="startEditing">

                    <VIcon name="pencil"/>
                </BButton>

                <BButton 
                    size="sm" 
                    variant="danger" 
                    title="Delete" 
                    v-confirm="{ action: remove, text: 'Are you sure you want to delete this story?' }">

                    <VIcon name="trash"/>
                </BButton>
            </td>

            <td v-if="isView('planning-backlog')">
                <BButton 
                    size="sm" 
                    variant="primary" 
                    title="Edit" 
                    @click="startEditing">

                    <VIcon name="pencil"/>
                </BButton>
            </td>
        </template>
    </tr>
</template>

<script>
import '@icons/arrows';
import '@icons/pencil';
import '@icons/trash';
import '@icons/arrow-up';
import '@icons/arrow-down';

import * as _ from 'lodash';
import VIcon from 'vue-awesome/components/Icon';
import BButton from '@bootstrap/button/button';
import BDropdown from '@bootstrap/dropdown/dropdown';
import BDropdownItem from '@bootstrap/dropdown/dropdown-item';
import StoryForm from '@/components/forms/StoryForm';
import bus from '@/helper/bus';

export default {
    name: 'StoryItem',
    components: { VIcon, StoryForm, BButton, BDropdown, BDropdownItem },
    props: {
        data: {
            type: Object,
            default: () => {},
        },
        view: {
            type: String,
            default: 'backlog',
        },
        position: {
            type: Number,
            default: null,
        },
        sortable: {
            type: Boolean,
            default: false,
        },
        highlight: {
            type: Boolean,
            default: false,
        },
    },
    data() {
        return {
            editing: false,
            editingData: null,
            statusMap: this.$store.state.stories.statusMap,
            keyboardSorting: false,
            expandedView: false,
        };
    },
    computed: {
        project() {
            return this.$store.getters['projects/byId'](this.data.project_id);
        },
        nextSprint() {
            return this.project
                ? this.$store.getters['sprints/next'](this.project.course_id)
                : null;
        }
    },
    methods: {
        /**
         * Check if we're operating in a given view
         * @param {(string|array)} view 
         * @returns {boolean}
         */
        isView(view) {
            if (Array.isArray(view)) {
                return view.indexOf(this.view) > -1;
            } else {
                return this.view === view;
            }
        },

        topic(topicId) {
            return this.$store.getters['topics/byId'](topicId);
        },

        /**
         * Start editing process of this story
         */
        startEditing() {
            this.editing = true;
            this.editingData = _.pick(this.data, [
                'title',
                'description',
                'points',
                'topic_id',
            ]);

            this.$store.commit('newPendingChange');

            bus.$on('saveAll', this.save);
        },

        cancelEdit() {
            this.editing = false;
            this.$store.commit('resolvePendingChange');
            bus.$off('saveAll', this.save);
        },

        startKeyboardSort() {
            this.keyboardSorting = true;
            window.addEventListener('keydown', this.move);
            this.$emit('moveStart', this.data.id);
        },

        stopKeyboardSort() {
            this.keyboardSorting = false;
            window.removeEventListener('keydown', this.move);
        },

        move(evt) {
            if (this.keyboardSorting) {
                switch(evt.keyCode) {
                    // enter
                    case 13:
                        evt.preventDefault();
                        this.stopKeyboardSort();
                        this.$emit('moveComplete', this.data.id);
                        break;
                    // esc
                    case 27:
                        evt.preventDefault();
                        this.stopKeyboardSort();
                        this.$emit('moveAbort', this.data.id);
                        break;
                    // arrow up
                    case 38:
                        evt.preventDefault();
                        this.$emit('move', this.data.id, -1);
                        break;
                    // arrow down
                    case 40:
                        evt.preventDefault();
                        this.$emit('move', this.data.id, 1);
                        break;
                    default:
                        // do nothing
                }
            }
        },

        /**
         * Save the edited parameters of this story
         */
        async save() {
            await this.$store.dispatch('stories/update', {
                id: this.data.id,
                parentId: this.data.project_id,
                ...this.editingData,
            });

            this.editing = false;

            this.$store.commit('resolvePendingChange');
            bus.$off('saveAll', this.save);

            // TODO handle errors in UI
        },

        /**
         * Delete this story
         */
        remove() {
            this.$store.dispatch('stories/remove', {
                id: this.data.id,
                parentId: this.data.project_id,
            });
        },

        /**
         * Save new status of story
         * @param {int} statusId
         */
        async saveStatus(statusId) {
            await this.$store.dispatch('stories/update', {
                id: this.data.id,
                parentId: this.data.project_id,
                status: statusId,
            });

            // TODO handle errors in UI
        },

        /**
         * Add story to sprint
         */
        async addToSprint() {
            if (!this.nextSprint) {
                return;
            }

            await this.$store.dispatch('stories/update', {
                id: this.data.id,
                parentId: this.project.id,
                sprint_id: this.nextSprint.id,
            });

            await this.$store.dispatch('projects/fetch', {
                id: this.project.id,
            });

            // TODO handle errors in UI
        },

        /**
         * Remove story from sprint
         */
        async removeFromSprint() {
            await this.$store.dispatch('stories/update', {
                id: this.data.id,
                parentId: this.project.id,
                sprint_id: null,
            });

            await this.$store.dispatch('projects/fetch', {
                id: this.project.id,
            });

            // TODO handle errors in UI
        },
    },
};
</script>

<style module>
    .fade {
        fill: #ccc;
    }

    .highlight {
        border: 3px solid #76b900;
    }
</style>