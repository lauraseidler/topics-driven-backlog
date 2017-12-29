/**
 * Check if a value is larger or equal than a given value in the parent
 * @param {string} compareValue Value to compare agains
 * @returns {boolean}
 */
export default compareValue =>
    function smallerOrEqualThan(value, parentVm) {
        // if both values are set, the given value must be smaller than the compare value
        return (
            !parentVm[compareValue] || !value || value <= parentVm[compareValue]
        );
    };
