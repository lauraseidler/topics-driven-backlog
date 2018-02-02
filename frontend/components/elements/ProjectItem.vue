<template>
    <li class="project-item card">
        <div 
            v-if="view === 'new'" 
            :class="$style.full">

            <div 
                v-if="!editing" 
                @click="startEditing"
                :class="$style.full" >

                <VIcon 
                    name="plus" 
                    scale="2"/>

                <strong>Create new project <br>in course</strong>
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
                    v-if="data.permissions && data.permissions.project.delete"
                    size="sm"
                    variant="outline-danger"
                    class="float-right ml-1"
                    v-confirm="{ action: deleteProject, text: 'Are you sure you want to delete this project?' }">
                    
                    <VIcon name="trash"/>
                </BButton>

                <BButton
                    v-if="data.permissions && data.permissions.project.update"
                    size="sm"
                    variant="outline-primary"
                    class="float-right ml-1"
                    @click="startEditing">

                    <VIcon name="pencil"/>
                </BButton>

                <h3 class="card-title h4">
                    <router-link 
                        v-if="isEnrolled" 
                        :to="baseUrl">
                        
                        {{ data.title }}
                    </router-link>

                    <template v-else> {{ data.title }}</template>

                    <template v-if="displayCourse"> 
                        <br> <small class="text-muted">{{ course.title }} </small>
                    </template>
                </h3>

                <p :class="['card-text', $style.bottom]">
                    <router-link
                        v-if="data.permissions && data.permissions.stories.read"
                        class="btn btn-primary"
                        :to="baseUrl">View Backlog</router-link>

                    <BButton
                        v-if="data.permissions && data.permissions.project.disenroll"
                        variant="primary"
                        v-confirm="{ action: disenroll, text: 'Do you really want to leave this project?' }"
                    >Leave project</BButton>

                    <BButton
                        v-if="data.permissions && data.permissions.project.enroll"
                        variant="primary"
                        @click="enroll"
                    >Join project</BButton>
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
import { slugify } from '@/helper/util';

export default {
    name: 'ProjectItem',
    components: { ProjectForm, BButton, VIcon },
    props: {
        data: {
            type: Object,
            default: null,
        },
        view: {
            type: String,
            default: 'standard',
        },
        courseId: {
            type: Number,
            default: null,
        },
        displayCourse: {
            type: Boolean,
            default: false,
        },
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

        isEnrolled() {
            return this.data.user_ids 
                && this.data.user_ids.indexOf(this.$store.state.user.id) > -1;
        },

        projectsInCourse() {
            return this.$store.getters['projects/all'](this.data.course_id);
        },

        isEnrolledToProjectInCourse() {
            return this.projectsInCourse.filter(
                p => p.user_ids &&  p.user_ids.indexOf(this.$store.state.user.id) > -1
            ).length > 0;
        },
    },
    methods: {
        slugify,

        /**
         * Start editing process of this project
         */
        startEditing() {
            this.editing = true;
            this.editingData = _.pick(this.data, [
                'title',
            ]);
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
                /* istanbul ignore next */
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
            try {
                await this.$store.dispatch('projects/remove', {
                    id: this.data.id,
                    parentId: this.data.course_id,
                });
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Delete failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
        },

        async addProject() {
            try {
                await this.$store.dispatch('projects/create', {
                    parentId: this.courseId,
                    ...this.editingData,
                });

                this.editing = false;
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Validation failed',
                    text: err.body.message.replace('Validation failed: ', ''),
                    type: 'error',
                });
            }
        },

        async enroll() {
            try {
                await this.$store.dispatch('projects/enroll', this.data.id);
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Enrollment failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
        },

        async disenroll() {
            try {
                await this.$store.dispatch('projects/disenroll', {
                    projectId: this.data.id,
                    courseId: this.course.id,
                });
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Disenrollment failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
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