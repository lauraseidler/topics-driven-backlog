<template>
    <li class="course-item card">
        <div class="card-body">
            <template v-if="!editing">
                <BButton
                    size="sm"
                    variant="outline-danger"
                    class="float-right ml-1"
                    v-confirm="{ action: deleteCourse, text: 'Are you sure you want to delete this course?' }">

                    <VIcon name="trash"/>
                </BButton>

                <BButton
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
                    class="card-text mt-2"
                    v-if="data.hyperlink">

                    <a :href="data.hyperlink">{{ data.hyperlink }}</a>
                </p>

                <router-link
                    :to="`/courses/${data.id}-${slugify(data.title)}`"
                    class="btn btn-primary">
                    View projects, topics and sprints
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
            default: () => {},
        },
    },
    computed: {

    },
    data() {
        return {
            editing: false,
            editingData: null,
        };
    },
    methods: {
        /**
         * Semester info for given type and year
         * @param {string} type
         * @param {string} year
         * @returns {{semesterStart: *, semester: string, year: number, fullString: string, valueString: string}}
         */
        getSemesterInfo(type, year) {
            return info(type, year);
        },

        /**
         * Slugify a text
         * @param text
         * @returns {string}
         */
        slugify(text) {
            return text.toString().toLowerCase()
                .replace(/\s+/g, '-')           // Replace spaces with -
                .replace(/[^\w\-]+/g, '')       // Remove all non-word chars
                .replace(/\-\-+/g, '-')         // Replace multiple - with single -
                .replace(/^-+/, '')             // Trim - from start of text
                .replace(/-+$/, '');            // Trim - from end of text
        },

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
            await this.$store.dispatch('courses/update', {
                id: this.data.id,
                ...this.editingData,
            });

            this.editing = false;

            // TODO handle errors in UI
        },

        /**
         * Delete this course
         */
        async deleteCourse() {
            await this.$store.dispatch('courses/remove', {
                id: this.data.id,
            });

            // TODO handle errors in UI
        },
    },
};
</script>