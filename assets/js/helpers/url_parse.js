const urlParams = () => {
  const urlSearch = window.location.search;
  const hashes = urlSearch.slice(urlSearch.indexOf('?') + 1).split('&');
  const params = {};

  hashes.map(hash => {
    let [key, val] = hash.split('=');
    params[key] = decodeURIComponent(val);
  });

  return params;
};

export default urlParams;
