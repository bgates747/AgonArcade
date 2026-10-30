esp_err_t dspm_mult_f32_ansi(const float *A, const float *B, float *C, int m, int n, int k)
{
    for (int i = 0 ; i < m ; i++) {
        for (int j = 0 ; j < k ; j++) {
            C[i * k + j] = A[i * n] * B[j];
            for (int s = 1; s < n ; s++) {
                C[i * k + j] += A[i * n + s] * B[s * k + j];
            }
        }
    }
    return ESP_OK;
}
