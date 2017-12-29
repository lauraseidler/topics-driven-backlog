/**
 * Check if a value is larger or equal than a given value in the parent, or directly given value
 * @param {string} compareValue Value to compare agains
 * @param {boolean} asIs If the value should be taken as is, or is the key to look up the value
 * @returns {boolean}
 */
export default (compareValue, asIs = false) =>
    function largerOrEqualThan(value, parentVm) {
        if (asIs) {
            return value >= compareValue;
        }

        // if both values are set, the given value must be larger than the compare value
        return (
            !parentVm[compareValue] || !value || value >= parentVm[compareValue]
        );
    };
