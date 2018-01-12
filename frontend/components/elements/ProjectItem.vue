<template>
    <li class="project-item card">
        <div 
            v-if="view === 'manage'" 
            class="card-body">

            <template v-if="!editing">
                <BButton 
                    size="sm" 
                    variant="danger" 
                    class="float-right ml-2" 
                    v-confirm="deleteProject">Delete</BButton>

                <BButton 
                    size="sm" 
                    variant="primary" 
                    class="float-right" 
                    @click="startEditing">Edit</BButton>
                
                <h3 class="card-title h5">{{ data.title }}</h3>
            </template>

            <ProjectForm 
                v-else 
                v-model="editingData" 
                @cancel="editing = false" 
                @submit="saveProject"/>
        </div>

        <div v-else-if="view === 'new'" :class="$style.full">
            <div :class="$style.full" v-if="!editing" @click="startEditing">
                <VIcon name="plus" scale="2"/>
            </div>

            <ProjectForm
                v-else
                v-model="editingData"
                @cancel="editing = false"
                @submit="emitProject"/>
        </div>

        <div 
            v-else 
            :class="['card-body', $style.display]">

            <h3 class="card-title h4">
                <router-link :to="baseUrl">{{ data.title }}</router-link>
            </h3>

            <p class="card-text">
                <router-link 
                    class="btn btn-primary mr-2 mb-2"
                    :to="backlogUrl">Backlog</router-link>

                <router-link
                    class="btn btn-primary mr-2 mb-2"
                    :to="sprintPlanningUrl">Sprint planning</router-link>
            </p>
        </div> 
    </li>
</template>

<script>
import '@icons/plus';

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
            default: 'manage',
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
            console.log(this.$store.getters);
            return this.$store.getters['courses/byId'](this.data.course_id);
        },

        baseUrl() {
            return '/courses'
                + `/${this.data.course_id}-${this.slugify(this.course.title)}`
                + '/projects'
                + `/${this.data.id}-${this.slugify(this.data.title)}`;
        },

        backlogUrl() {
            return `${this.baseUrl}#backlog`;
        },

        sprintPlanningUrl() {
            return `${this.baseUrl}#sprint-planning`;
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
            await this.$store.dispatch('projects/update', {
                id: this.data.id,
                parentId: this.data.course_id,
                ...this.editingData,
            });

            this.editing = false;

            // TODO handle errors in UI
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

        emitProject() {
            this.$emit('submit', this.editingData);
            this.editing = false;
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
        display: flex;
        flex-direction: column;
        justify-content: space-between;
    }

    .full {
        height: 100%;
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: center;

        div {
            cursor: pointer;
        }
    }
</style>