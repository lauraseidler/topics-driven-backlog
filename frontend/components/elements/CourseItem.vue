<template>
    <li class="course-item card">
        <div class="card-body">
            <template v-if="!editing">
                <BButton
                    v-if="data.permissions.course.delete"
                    size="sm"
                    variant="outline-danger"
                    class="float-right ml-1"
                    v-confirm="{ action: deleteCourse, text: 'Are you sure you want to delete this course?' }">

                    <VIcon name="trash"/>
                </BButton>

                <BButton
                    v-if="data.permissions.course.update"
                    size="sm"
                    variant="outline-primary"
                    class="float-right ml-1"
                    @click="startEditing">

                    <VIcon name="pencil"/>
                </BButton>

                <router-link
                    :to="`/courses/${data.id}-${slugify(data.title)}`"
                    class="h4 card-title link-unstyled">
                    {{ data.short_title }}
                </router-link>

                <h5 class="h6 text-muted card-subtitle mt-0">
                    {{ data.title }} ({{ getSemesterInfo(data.semester_type, data.semester_year).fullString }})
                </h5>

                <p
                    class="card-text mt-2 mb-0"
                    v-if="data.hyperlink">

                    <a :href="data.hyperlink">{{ data.hyperlink }}</a>
                </p>

                <router-link
                    :to="`/courses/${data.id}-${slugify(data.title)}`"
                    class="btn btn-primary mt-2">
                    View details
                </router-link>
            </template>

            <CourseForm
                v-else
                no-semester
                v-model="editingData"
                @cancel="editing = false"
                @submit="saveCourse"/>
        </div>
    </li>
</template>

<script>
import '@icons/pencil';
import '@icons/trash';

import { info } from '@/helper/semester';
import { slugify } from '@/helper/util';
import * as _ from 'lodash';
import VIcon from 'vue-awesome/components/Icon';
import BButton from '@bootstrap/button/button';
import CourseForm from '@/components/forms/CourseForm';

export default {
    name: 'CourseItem',
    components: { CourseForm, BButton, VIcon },
    props: {
        data: {
            type: Object,
            default: null,
            validator: function (value) {                
                return value
                    && value.id 
                    && value.title 
                    && value.semester_type 
                    && value.semester_year;
            },
        },
    },
    data() {
        return {
            editing: false,
            editingData: null,
        };
    },
    methods: {
        slugify,
        getSemesterInfo: info,

        /**
         * Start editing process of this sprint
         */
        startEditing() {
            this.editing = true;
            this.editingData = _.pick(this.data, [
                'short_title',
                'title',
                'hyperlink',
                'allow_enrollment',
            ]);
        },

        /**
         * Save the edited parameters of this course
         */
        async saveCourse() {        
            try {
                await this.$store.dispatch('courses/update', {
                    id: this.data.id,
                    ...this.editingData,
                });
                this.editing = false;
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Course update failed',
                    text: err.body.message,
                    type: 'error',
                });
            } 
        },

        /**
         * Delete this course
         */
        async deleteCourse() {
            try {
                await this.$store.dispatch('courses/remove', {
                    id: this.data.id,
                });
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Course delete failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
        },
    },
};
</script>