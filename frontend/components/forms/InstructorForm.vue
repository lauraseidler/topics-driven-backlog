<template>
    <BForm
        @submit.prevent="submit"
        class="instructor-form">

        <BFormGroup 
            label="Add instructor by email"
            label-for="instructor-email">

            <BFormInput 
                ref="focusInput"
                id="instructor-email"
                v-model="email"
                required/>
        </BFormGroup>

        <BButton 
            type="submit" 
            variant="primary"
            :class="{ 'is-disabled': isInvalid }">Save</BButton>
    </BForm>
</template>

<script>
import { required, email } from 'vuelidate/lib/validators';
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BButton from '@bootstrap/button/button';
import BaseForm from '@/components/forms/BaseForm';

export default {
    name: 'InstructorForm',
    components: { BForm, BFormGroup, BFormInput, BButton },
    extends: BaseForm,
    props: {
        courseId: {
            type: Number,
            required: true,
        },
    },
    data() {
        return {
            email: '',
        };
    },
    methods: {
        async submit() {
            if (this.$v && this.isInvalid) {
                return;
            }

            try {
                await this.$store.dispatch('courses/addInstructor', {
                    id: this.courseId,
                    email: this.email,
                });

                this.email = '';
            } catch (err) {
                /* istanbul ignore next */
                this.$notify({
                    title: 'Course update failed',
                    text: err.body.message,
                    type: 'error',
                });
            }
        },
    },
    validations: {
        email: { required, email }
    },
};
</script>
