import Vue from 'vue';
import axios from 'axios';
import moment from 'moment';
import urlParams from './helpers/url_parse';

const app = new Vue({
  el: '#trackerContainer',
  data: {
    weeklyHours: {}
  },

  created() {
    this.getWeekly();
  },

  computed: {
    displayedWeek() {
      const date = urlParams().date;

      if (date === undefined) {
        return moment().week();
      } else {
        return moment(date).week();
      }
    },
    currentWeek() {
      return moment().week();
    }
  },

  methods: {
    getWeekly() {
      axios.get('/entries/weekly')
        .then(response => {
          this.weeklyHours = response.data;
        });
    },

    padNumber(number) {
      return number < 10 ? `0${number}` : number;
    },

    getDate(weekNum) {
      return moment().day('Monday').week(weekNum).format('YYYY-MM-DD');
    },

    generateUrl(weekNum) {
      const date = this.getDate(weekNum);
      return `/dashboard?date=${date}`;
    },

    getCssClasses(weekNum) {
      const hours = this.weeklyHours.weeks[weekNum] || 0;
      const target = this.weeklyHours.target * 5;
      const notFuture = weekNum <= this.currentWeek;

      return {
        'empty': hours === 0 && notFuture,
        'incomplete': hours > 0 && hours < target,
        'complete': hours >= target,
        'active': weekNum === this.displayedWeek
      };
    }
  }
});
