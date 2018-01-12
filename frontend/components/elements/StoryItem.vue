<template>
    <tr class="story-item">
        <td 
            v-if="editing" 
            colspan="6">

            <StoryForm
                :project="project"
                v-model="editingData" 
                @cancel="editing = false" 
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

                <span class="js-drag-drop ml-2" v-if="isView(['backlog', 'planning-sprint'])" title="Drag to change order">
                    <VIcon 
                        name="arrows" 
                        label="Drag and drop to change order"/>
                </span>
                <!--{{ data.position }}-->
            </td>

            <!-- Identifier -->
            <td>
                {{ data.identifier }}
            </td>

            <!-- Story -->
            <td>
                {{ data.title }}
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
    },
    data() {
        return {
            editing: false,
            editingData: null,
            statusMap: this.$store.state.stories.statusMap,
        };
    },
    computed: {
        project() {
            return this.$store.getters['projects/byId'](this.data.project_id);
        },
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
         * Emit addToSprint event to parent
         */
        addToSprint() {
            this.$emit('addToSprint');
        },

        /**
         * Emit removeFromSprint event to parent
         */
        removeFromSprint() {
            this.$emit('removeFromSprint');
        },
    },
};
</script>