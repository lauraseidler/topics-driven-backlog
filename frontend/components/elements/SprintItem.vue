<template>
    <li class="sprint-item card">
        <div class="card-body">
            <template v-if="!editing">
                <template v-if="data.end_date >= currentDate">
                    <BButton 
                        size="sm" 
                        variant="danger" 
                        class="float-right ml-2" 
                        v-confirm="deleteSprint">Delete</BButton>

                    <BButton 
                        size="sm" 
                        variant="primary" 
                        class="float-right" 
                        @click="startEditing">Edit</BButton>
                </template>
                
                <h3 class="card-title h5">{{ data.name }}</h3>

                <p class="card-text">
                    Start: {{ data.start_date | displayDate }} <br>
                    End: {{ data.end_date | displayDate }}
                </p>
            </template>

            <SprintForm 
                v-else 
                v-model="editingData" 
                @cancel="editing = false" 
                @submit="saveSprint"/>
        </div>
    </li>
</template>

<script>
import * as _ from 'lodash';
import moment from 'moment';
import BButton from '@bootstrap/button/button';
import SprintForm from '@/components/forms/SprintForm';

export default {
    name: 'SprintItem',
    components: { SprintForm, BButton },
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
            currentDate: moment().format('YYYY-MM-DD'),
        };
    },
    methods: {
        /**
         * Start editing process of this sprint
         */
        startEditing() {
            this.editing = true;
            this.editingData = _.pick(this.data, [
                'name',
                'start_date',
                'end_date',
            ]);
        },

        /**
         * Save the edited parameters of this sprint
         */
        async saveSprint() {
            await this.$store.dispatch('sprints/update', {
                id: this.data.id,
                parentId: this.data.course_id,
                ...this.editingData,
            });

            this.editing = false;

            // TODO handle errors in UI
        },

        /**
         * Delete this sprint
         */
        async deleteSprint() {
            await this.$store.dispatch('sprints/remove', {
                id: this.data.id,
                parentId: this.data.course_id,
            });

            // TODO handle errors in UI
        },
    },
};
</script>