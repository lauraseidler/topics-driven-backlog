import moment from 'moment';

/**
 * Check if a value is in a valid date format
 * @returns {boolean}
 */
export default () =>
    function date(value) {
        return moment(value, 'YYYY-MM-DD').isValid();
    };
