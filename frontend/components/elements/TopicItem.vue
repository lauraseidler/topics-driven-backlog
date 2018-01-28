<template>
    <li class="topic-item card">
        <div class="card-body">
            <template v-if="!editing">
                <BButton
                    size="sm"
                    variant="outline-danger"
                    class="float-right ml-1"
                    v-confirm="{
                        action: deleteTopic,
                        text: 'Are you sure you want to delete this topic? This will remove the topic link from all associated stories.'
                }">

                    <VIcon name="trash"/>
                </BButton>

                <BButton
                    size="sm"
                    variant="outline-primary"
                    class="float-right ml-1"
                    @click="startEditing">

                    <VIcon name="pencil"/>
                </BButton>

                
                <h3 class="card-title h5">{{ data.title }}</h3>

                <p class="card-text" v-if="data.url">
                    <a :href="data.url">{{ data.url }}</a>
                </p>
            </template>

            <TopicForm
                v-else 
                v-model="editingData" 
                @cancel="editing = false" 
                @submit="saveTopic"/>
        </div>
    </li>
</template>

<script>
import '@icons/pencil';
import '@icons/trash';

import * as _ from 'lodash';
import VIcon from 'vue-awesome/components/Icon';
import BButton from '@bootstrap/button/button';
import TopicForm from '@/components/forms/TopicForm';

export default {
    name: 'TopicItem',
    components: { TopicForm, BButton, VIcon },
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
         * Start editing process of this sprint
         */
        startEditing() {
            this.editing = true;
            this.editingData = _.pick(this.data, [
                'title',
                'url',
            ]);
        },

        /**
         * Save the edited parameters of this sprint
         */
        async saveTopic() {
            await this.$store.dispatch('topics/update', {
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
        async deleteTopic() {
            await this.$store.dispatch('topics/remove', {
                id: this.data.id,
                parentId: this.data.course_id,
            });

            // TODO handle errors in UI
        },
    },
};
</script>