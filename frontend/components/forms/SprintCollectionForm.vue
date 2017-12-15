<template>
    <b-form @submit.prevent="submit">

        <b-row>
            <b-col md="6">
                <h4>Add multiple sprints</h4>
                <p>
                    This feature allows you to add multiple sprints at the same time. Just enter a sprint length in days
                    (for example 7 for week-long sprints) and the start and end date of the period you'd like to generate sprints for.
                    You can view a preview of the sprints that are going to be generated for you on the right.
                    Please note that you can only add future sprints with this feature.
                </p>

                <b-form-group label="Sprint length in days" label-for="sprint-collection-duration">
                    <b-form-input id="sprint-collection-duration" type="number" min="1" step="1" v-model="data.duration" required></b-form-input>
                </b-form-group>

                <b-form-group label="Start date" label-for="sprint-collection-start-date">
                    <b-form-input id="sprint-collection-start-date" :min="$store.state.currentDate" type="date" v-model="data.start_date" required></b-form-input>
                </b-form-group>

                <b-form-group label="End date" label-for="sprint-collection-end-date">
                    <b-form-input id="sprint-collection-end-date" :min="data.start_date" type="date" v-model="data.end_date" required></b-form-input>
                </b-form-group>

                <b-button type="submit" variant="primary" :disabled="isInvalid">Add sprints</b-button>
                <b-button type="button" variant="grey" @click="cancel">Cancel</b-button>
            </b-col>
            <b-col md="6">
                <h4>Preview</h4>
                <p v-if="isInvalid">
                    Please fill out all fields correctly to generate the preview.
                </p>

                <p v-else-if="numberOfSprints < 1">
                    We cannot fit any sprints of the given duration into the period you provided.
                </p>

                <template v-else>
                    <div v-for="i in numberOfSprints">
                        <strong>{{i}}. Sprint:</strong>
                        {{ datePlusDays(data.start_date, (i - 1) * data.duration) }}
                        -
                        {{ datePlusDays(data.start_date, i * data.duration - 1) }}
                    </div>
                </template>
            </b-col>
        </b-row>
    </b-form>
</template>

<script>
    import {required, minValue} from 'vuelidate/lib/validators';
    import smallerOrEqualThan from '../../validators/smallerOrEqualThan';
    import largerOrEqualThan from '../../validators/largerOrEqualThan';
    import BaseForm from './BaseForm.vue';
    import moment from "moment";

    export default {
        name: 'sprint-collection-form',
        extends: BaseForm,
        computed: {
            numberOfDays() {
                if (this.isInvalid) {
                    return -1;
                }

                const start = moment(this.data.start_date, 'YYYY-MM-DD');
                const end = moment(this.data.end_date, 'YYYY-MM-DD');

                // add 1 since both start and end date are included
                return end.diff(start, 'days') + 1;
            },
            numberOfSprints() {
                return this.numberOfDays ? Math.floor(this.numberOfDays/this.data.duration) : 0;
            },
        },
        methods: {
            /**
             * Add a number of days to a given date
             * @param date
             * @param days
             * @returns {string}
             */
            datePlusDays(date, days) {
                return moment(date, 'YYYY-MM-DD').add(days, 'days').format('YYYY-MM-DD');
            },
        },
        validations: {
            data: {
                duration: {required},
                start_date: {
                    required,
                    smallerThanEnd: smallerOrEqualThan('end_date'),
                    largerThanToday: largerOrEqualThan(moment().format('YYYY-MM-DD'), true),
                },
                end_date: {
                    required,
                    largerThanStart: largerOrEqualThan('start_date')
                },
            },
        },
    }
</script>