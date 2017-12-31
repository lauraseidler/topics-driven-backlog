<template>
    <li class="project-item card">
        <div class="card-body">
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
    </li>
</template>

<script>
import * as _ from 'lodash';
import BButton from '@bootstrap/button/button';
import ProjectForm from '@/components/forms/ProjectForm';

export default {
    name: 'ProjectItem',
    components: { ProjectForm, BButton },
    props: {
        data: {
            type: Object,
            default: () => {},
        },
    },
    data() {
        return {
            editing: false,
            editingData: null,
        };
    },
    methods: {
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
        saveProject() {
            this.$store
                .dispatch('projects/patch', {
                    id: this.data.id,
                    values: this.editingData,
                })
                .then(() => {
                    this.editing = false;
                });
        },

        /**
         * Delete this project
         */
        deleteProject() {
            this.$store.dispatch('projects/delete', {
                id: this.data.id,
                course_id: this.data.course_id,
            });
        },
    },
};
</script>