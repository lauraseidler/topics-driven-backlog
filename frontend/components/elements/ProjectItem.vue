<template>
    <li class="project-item card">
        <div v-if="view === 'new'" :class="$style.full">
            <div :class="$style.full" v-if="!editing" @click="startEditing">
                <VIcon name="plus" scale="2"/>
                <strong>Create new project <br> in course</strong>
            </div>

            <ProjectForm
                v-else
                v-model="editingData"
                @cancel="editing = false"
                @submit="addProject"/>
        </div>

        <div 
            v-else 
            :class="['card-body', $style.display]">

            <template v-if="!editing">
                <BButton
                        size="sm"
                        variant="outline-danger"
                        class="float-right ml-2"
                        v-confirm="{ action: deleteProject, text: 'Are you sure you want to delete this project?' }">
                    <VIcon name="trash"/>
                    Delete
                </BButton>

                <BButton
                        size="sm"
                        variant="outline-primary"
                        class="float-right ml-2"
                        @click="startEditing">
                    <VIcon name="pencil"/>
                    Edit
                </BButton>

                <h3 class="card-title h4">
                    <router-link :to="baseUrl">{{ data.title }}</router-link>
                </h3>

                <p :class="['card-text', $style.bottom]">
                    <router-link
                        class="btn btn-primary"
                        :to="baseUrl">View Backlog</router-link>
                </p>
            </template>

            <ProjectForm
                    v-else
                    v-model="editingData"
                    @cancel="editing = false"
                    @submit="saveProject"/>
        </div>
    </li>
</template>

<script>
import '@icons/plus';
import '@icons/pencil';
import '@icons/trash';

import * as _ from 'lodash';
import VIcon from 'vue-awesome/components/Icon';
import BButton from '@bootstrap/button/button';
import ProjectForm from '@/components/forms/ProjectForm';

export default {
    name: 'ProjectItem',
    components: { ProjectForm, BButton, VIcon },
    props: {
        data: {
            type: Object,
            default: () => {},
        },
        view: {
            type: String,
            default: 'standard',
        },
        courseId: {
            type: Number,
            default: null,
        }
    },
    data() {
        return {
            editing: false,
            editingData: {},
        };
    },
    computed: {
        course() {
            return this.$store.getters['courses/byId'](this.data.course_id);
        },

        baseUrl() {
            return '/projects'
                + `/${this.data.id}-${this.slugify(this.data.title)}`;
        },
    },
    methods: {
        /**
         * Start editing process of this project
         */
        startEditing() {
            if (!this.editing){
                this.editing = true;
                this.editingData = _.pick(this.data, [
                    'title',
                ]);
            }
        },

        /**
         * Save the edited parameters of this project
         */
        async saveProject() {
            try {
                await this.$store.dispatch('projects/update', {
                    id: this.data.id,
                    parentId: this.data.course_id,
                    ...this.editingData,
                });

                this.editing = false;
            } catch (err) {
                this.$notify({
                    title: 'Validation failed',
                    text: err.body.message.replace('Validation failed: ', ''),
                    type: 'error',
                });
            }
        },

        /**
         * Delete this project
         */
        async deleteProject() {
            await this.$store.dispatch('projects/remove', {
                id: this.data.id,
                parentId: this.data.course_id,
            });

            // TODO handle errors in UI
        },

        async addProject() {
            try {
                await this.$store.dispatch('projects/create', {
                    parentId: this.courseId,
                    ...this.editingData,
                });

                this.editing = false;
            } catch (err) {
                this.$notify({
                    title: 'Validation failed',
                    text: err.body.message.replace('Validation failed: ', ''),
                    type: 'error',
                });
            }
        },

        slugify(text) {
            return text.toString().toLowerCase()
                .replace(/\s+/g, '-')           // Replace spaces with -
                .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
                .replace(/\-\-+/g, '-')         // Replace multiple - with single -
                .replace(/^-+/, '')             // Trim - from start of text
                .replace(/-+$/, '');            // Trim - from end of text
        },
    },
};
</script>

<style lang="scss" module>
    .display {
        position: relative;
    }

    .bottom {
        position: absolute;
        left: 20px;
        bottom: 20px;
    }

    .full {
        height: 100%;
        width: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        text-align: center;

        div {
            cursor: pointer;
        }

        form {
            text-align: left;
        }
    }
</style>