<template>
    <BForm
        @submit.prevent="submit"
        class="login-form">

        <BFormGroup
            label="Username"
            label-for="login-username">

            <BFormInput
                id="login-username"
                v-model="data.username"
                required/>
        </BFormGroup>

        <BFormGroup
            label="Password"
            label-for="login-password">

            <BFormInput
                id="login-password"
                type="password"
                v-model="data.password"
                required/>
        </BFormGroup>

        <BButton
            type="submit"
            variant="primary"
            :class="{ 'is-disabled': isInvalid }">
            Login
        </BButton>
    </BForm>
</template>

<script>
import BForm from '@bootstrap/form/form';
import BFormGroup from '@bootstrap/form-group/form-group';
import BFormInput from '@bootstrap/form-input/form-input';
import BButton from '@bootstrap/button/button';
import BaseForm from '@/components/forms/BaseForm';
import { required } from 'vuelidate/lib/validators';

export default {
    name: 'login-form',
    components: { BForm, BFormGroup, BFormInput, BButton },
    extends: BaseForm,
    validations: {
        data: {
            username: { required },
            password: { required },
        },
    },
};
</script>