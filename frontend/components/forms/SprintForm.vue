<template>
    <BForm 
        @submit.prevent="submit" 
        class="sprint-form">

        <BFormGroup 
            label="Name" 
            label-for="sprint-name">

            <BFormInput 
                id="sprint-name" 
                v-model="data.name" 
                required/>
        </BFormGroup>

        <BFormGroup 
            label="Start date" 
            label-for="sprint-start-date">

            <BFormInput 
                id="sprint-start-date" 
                :max="data.end_date" 
                type="date"
                v-model="data.start_date"
                placeholder="YYYY-MM-DD"
                required/>
        </BFormGroup>

        <BFormGroup 
            label="End date" 
            label-for="sprint-end-date">

            <BFormInput 
                id="sprint-end-date" 
                type="date"
                v-model="data.end_date"
                placeholder="YYYY-MM-DD"
                required
                :min="data.start_date"/>
        </BFormGroup>

        <BFormGroup
                label="Topics"
                label-for="sprint-topics">

            <BFormSelect
                    multiple
                    id="sprint-topics"
                    v-model="data.topic_ids">
                <option
                        v-for="topic in topics"
                        :value="topic.id"
                        :key="topic.id">

                    {{ topic.title }}
                </option>
            </BFormSelect>
        </BFormGroup>

        <div class="alert alert-warning" v-if="isOverlapping">
            <h4>Attention, overlapping sprints!</h4>
            <p>
                You have changed this sprint's dates, which results in an overlap with another sprint.
                You can choose to do this change regardless of overlapping dates, or have all other sprints adjusted to
                fit the new dates (by moving them back or forth, not affecting sprint length) by choosing a way of saving below.
                If you choose to adjust sprint dates, this is how the existing sprints will be affected:
            </p>
            <BRow>
                <BCol md="6">
                    <h5>Before</h5>
                    <p class="mb-0" v-for="sprint in sprints">
                        <strong>{{ sprint.name }}:</strong>
                        {{ sprint.start_date | displayDate }} - {{ sprint.end_date | displayDate }}
                    </p>
                </BCol>
                <BCol md="6">
                    <h5>After</h5>
                    <p class="mb-0" v-for="sprint in newSprints">
                        <strong>{{ sprint.name }}:</strong>
                        {{ sprint.start_date | displayDate }} - {{ sprint.end_date | displayDate }}
                    </p>
                </BCol>
            </BRow>
        </div>

        <BButton 
            type="submit" 
            variant="primary"
            :class="{ 'is-disabled': isInvalid }">
            {{ isOverlapping ? 'Save normally' : 'Save'}}
        </BButton>

        <BButton
            v-if="isOverlapping"
            @click="saveNewSprintDates"
            type="button"
            variant="primary"
            :class="{ 'is-disabled': isInvalid }">
            Save and adjust other sprint dates
        </BButton>

        <BButton 
            type="button" 
            variant="grey" 
            @click="cancel">Cancel</BButton>
    </BForm>
</template>

<script>
import moment from 'moment';
import { required } from 'vuelidate/lib/validators';
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BFormSelect from '@bootstrap/form-select/form-select';
import BButton from '@bootstrap/button/button';
import smallerOrEqualThan from '@/validators/smallerOrEqualThan';
import largerOrEqualThan from '@/validators/largerOrEqualThan';
import date from '@/validators/date';
import BaseForm from '@/components/forms/BaseForm';
import BRow from '@bootstrap/layout/row';
import BCol from '@bootstrap/layout/col';

export default {
    name: 'SprintForm',
    components: { BForm, BFormGroup, BFormInput, BFormSelect, BButton, BRow, BCol },
    extends: BaseForm,
    props: {
        course: {
            type: Object,
            default: () => {},
        },
    },
    computed: {
        topics() {
            return this.course
                ? this.$store.getters['topics/all'](this.course.id)
                : [];
        },
        sprints() {
            return this.course
                ? this.$store.getters['sprints/all'](this.course.id)
                : [];
        },
        overlapping() {
            let overlapping = false;
            let ownIndex;

            this.sprints.forEach((sprint, index) => {
                if (sprint.id === this.data.id) {
                    ownIndex = index;
                }

                if (
                    !overlapping
                    && sprint.id !== this.data.id
                    && (
                        (
                            this.data.start_date <= sprint.start_date
                            && this.data.end_date >= sprint.start_date
                        )
                        || (
                            this.data.end_date >= sprint.end_date
                            && this.data.start_date <= sprint.end_date
                        )
                    )
                ) {
                    overlapping = true;
                }
            });

            return {ownIndex, overlapping};
        },

        isOverlapping() {
            return this.overlapping.overlapping;
        },

        newSprints() {
            if (!this.isOverlapping) {
                return this.sprints;
            }

            const newSprints = this.sprints.slice(0);
            newSprints[this.overlapping.ownIndex] = {...this.data};
            newSprints.sort((a, b) => a.start_date.localeCompare(b.start_date));

            let newOwnIndex = newSprints.findIndex(s => s.id === this.data.id);

            for (let i = newOwnIndex + 1; i < newSprints.length; i++) {
                const endOther = moment(newSprints[i - 1].end_date);
                const startThis = moment(newSprints[i].start_date);
                const endThis = moment(newSprints[i].end_date);

                if (!endOther.isBefore(startThis)) {
                    const difference = moment.duration(endOther.diff(startThis)).asDays() + 1;

                    newSprints[i] = {
                        ...newSprints[i],
                        start_date: startThis.add(difference, 'days').format('YYYY-MM-DD'),
                        end_date: endThis.add(difference, 'days').format('YYYY-MM-DD'),
                    };
                }
            }

            newSprints.sort((a, b) => a.end_date.localeCompare(b.end_date));
            newOwnIndex = newSprints.findIndex(s => s.id === this.data.id);

            for (let i = newOwnIndex - 1; i >= 0; i--) {
                const startOther = moment(newSprints[i + 1].start_date);
                const startThis = moment(newSprints[i].start_date);
                const endThis = moment(newSprints[i].end_date);

                if (!startOther.isAfter(endThis)) {
                    const difference = moment.duration(endThis.diff(startOther)).asDays() + 1;

                    newSprints[i] = {
                        ...newSprints[i],
                        start_date: startThis.subtract(difference, 'days').format('YYYY-MM-DD'),
                        end_date: endThis.subtract(difference, 'days').format('YYYY-MM-DD'),
                    };
                }
            }

            return newSprints;
        },
    },
    methods: {
        async saveNewSprintDates() {
            try {
                await this.$store.dispatch('sprints/updateCollection', {
                    parentId: this.course.id,
                    collection: this.newSprints,
                });

                this.cancel();
            } catch (e) {
                this.$notify({
                    title: 'Update failed',
                    text: e.message,
                    type: 'error',
                });
            }


        },
    },
    validations: {
        data: {
            name: { required },
            start_date: {
                required,
                date,
                smallerThanEnd: smallerOrEqualThan('end_date'),
            },
            end_date: {
                required,
                date,
                largerThanStart: largerOrEqualThan('start_date'),
            },
        },
    },
};
</script>